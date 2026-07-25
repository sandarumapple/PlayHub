//
//  QuizRushVM.swift
//  PlayHub
//

import Foundation
import Combine



@MainActor
final class QuizRushVM: ObservableObject {

    let difficulty: GameDifficulty



    enum GameState {


        case loading

        case playing

        case failed(String)

        case finished


    }






    @Published var state:GameState = .loading



    @Published var questions:[TriviaQuestion] = []



    @Published var currentIndex = 0



    @Published var score = 0



    @Published var streak = 0



    @Published var highScore = 0



    @Published var selectedAnswer:String?






    var currentQuestion:TriviaQuestion? {


        guard currentIndex < questions.count

        else {

            return nil

        }


        return questions[currentIndex]

    }







    init(difficulty: GameDifficulty = .medium){

        self.difficulty = difficulty


        highScore =
        StorageService.shared
            .highScore(
                mode:.quizRush
            )


    }








    func load() async {


        state = .loading



        do {


            questions =
            try await TriviaAPI.shared
                .fetchQuestions(
                    difficulty: difficulty,
                    amount: difficulty.questionCount
                )



            currentIndex = 0

            score = 0

            streak = 0



            state = .playing



        }

        catch {


            state =
            .failed(
                error.localizedDescription
            )


        }


    }









    func choose(
        answer:String
    ) {



        guard let question =
                currentQuestion

        else {

            return

        }





        selectedAnswer = answer





        if answer ==
            question.correct_answer {



            streak += 1



            score +=
            10 + (streak * 2)




        } else {



            streak = 0



            score -= 5



            if score < 0 {


                score = 0


            }


        }





        DispatchQueue.main.asyncAfter(
            deadline:.now()+0.3
        ){


            self.next()


        }


    }








    func next(){


        selectedAnswer = nil



        currentIndex += 1





        if currentIndex >= questions.count {


            finish()


        }


    }








    func finish(){


        state = .finished




        StorageService.shared
            .saveGame(
                mode:.quizRush,
                score:score
            )



        highScore =
        StorageService.shared
            .highScore(
                mode:.quizRush
            )


    }






    func retry(){


        Task {


            await load()


        }


    }


}
