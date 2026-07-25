//
//  LightItUpVM.swift
//  PlayHub
//

import Foundation
import SwiftUI
import Combine


@MainActor
final class LightItUpVM: ObservableObject {

    let difficulty: GameDifficulty


    // MARK: Game State


    @Published var score = 0

    @Published var timeRemaining: Int

    @Published var activeCards:[Int] = []

    @Published var gameStarted = false

    @Published var gameOver = false

    @Published var currentLevel = 1





    // MARK: High Score


    @Published private(set) var highScore = 0






    private var timer: Timer?

    private var lightTask: DispatchWorkItem?


    init(difficulty: GameDifficulty = .medium) {

        self.difficulty = difficulty
        self.timeRemaining = difficulty.lightRoundDuration

        refreshHighScore()

    }








    // MARK: Start


    func startGame(){


        stopGame()


        refreshHighScore()



        score = 0

        timeRemaining = difficulty.lightRoundDuration

        currentLevel = 1

        activeCards.removeAll()



        gameStarted = true

        gameOver = false



        startTimer()

        moveLight()


    }









    // MARK: Timer


    private func startTimer(){


        timer =
        Timer.scheduledTimer(
            withTimeInterval:1,
            repeats:true
        ){ _ in



            Task { @MainActor in



                guard self.gameStarted
                else {
                    return
                }



                self.timeRemaining -= 1



                self.updateLevel()



                if self.timeRemaining <= 0 {


                    self.finishGame()


                }


            }



        }



    }









    // MARK: Level


    private func updateLevel(){


        switch timeRemaining {


        case 46...60:

            currentLevel = 1


        case 31...45:

            currentLevel = 2


        case 16...30:

            currentLevel = 3


        default:

            currentLevel = 4


        }


    }









    // MARK: Grid


    var cardCount:Int {


        switch currentLevel {


        case 1:

            return 3


        case 2:

            return 4


        case 3:

            return 6


        default:

            return 9


        }


    }








    var columnCount:Int {


        switch currentLevel {


        case 1:

            return 3


        case 2:

            return 2


        default:

            return 3


        }


    }









    private var lightDuration:Double {


        switch currentLevel {


        case 1:

            return 1.5


        case 2:

            return 1.2


        case 3:

            return 1.0


        default:

            return 0.8


        }


    }









    // MARK: Move Light


    func moveLight(){


        guard gameStarted
        else {
            return
        }




        activeCards.removeAll()



        var cards =
        Array(
            0..<cardCount
        )



        cards.shuffle()



        activeCards.append(
            cards[0]
        )



        if currentLevel == 4 {


            activeCards.append(
                cards[1]
            )


        }






        lightTask?.cancel()



        let task =
        DispatchWorkItem {


            Task { @MainActor in


                if self.gameStarted {


                    self.moveLight()


                }


            }


        }



        lightTask = task



        DispatchQueue.main.asyncAfter(
            deadline:
                .now() + lightDuration * difficulty.lightSpeedMultiplier,
            execute:task
        )


    }









    // MARK: Tap


    func tapCard(
        _ index:Int
    ){


        guard gameStarted
        else {
            return
        }




        if activeCards.contains(index){



            score += 1




            moveLight()



        }



    }









    // MARK: Finish


    private func finishGame(){


        saveResult()



        gameStarted = false

        gameOver = true



        stopGame()


    }









    private func saveResult(){



        StorageService.shared.saveGame(
            mode:.lightItUp,
            score:score
        )





        refreshHighScore()






        NotificationCenter.default.post(
            name:
                .gameSaved,
            object:nil
        )


    }


    private func refreshHighScore(){


        highScore = StorageService.shared.highScoreForCurrentPlayer(
            mode:.lightItUp
        )


    }









    // MARK: Stop


    func stopGame(){


        timer?.invalidate()

        timer = nil



        lightTask?.cancel()

        lightTask = nil


    }








    deinit {


        timer?.invalidate()

        lightTask?.cancel()


    }


}
