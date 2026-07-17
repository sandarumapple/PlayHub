//
//  TapFrenzyVM.swift
//  PlayHub
//

import Foundation
import Combine


@MainActor
final class TapFrenzyVM: ObservableObject {


    @Published var score = 0

    @Published var time = 10

    @Published var gameOver = false

    @Published var combo = 1

    @Published var highScore = 0

    @Published var doublePoints = false

    @Published var isStarted = false



    private var timer: AnyCancellable?





    init() {


        highScore =
        StorageService.shared
            .highScore(
                mode: .tapFrenzy
            )

    }







    func start() {


        timer?.cancel()



        score = 0

        time = 10

        combo = 1

        doublePoints = false

        gameOver = false

        isStarted = true





        timer =
        Timer.publish(
            every: 1,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in


            self?.countDown()


        }


    }








    func tap() {


        guard !gameOver else {
            return
        }



        let points =
        doublePoints ? 2 : 1



        score += points * combo



        combo += 1



        if combo > 5 {


            combo = 5


        }


    }








    private func countDown() {


        time -= 1



        if time <= 0 {


            finish()


        }


    }









    func activateDoublePoints() {


        doublePoints = true




        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2
        ) {


            self.doublePoints = false


        }


    }









    func finish() {


        timer?.cancel()



        gameOver = true






        StorageService.shared
            .saveGame(
                mode: .tapFrenzy,
                score: score
            )






        highScore =
        StorageService.shared
            .highScore(
                mode: .tapFrenzy
            )


    }








    func restart() {


        start()


    }


}
