//
//  TriviaQuestion.swift
//  PlayHub
//

import Foundation



struct TriviaResponse: Codable {


    let response_code:Int

    let results:[TriviaQuestion]


}






struct TriviaQuestion: Codable, Identifiable {


    let id = UUID()



    let category:String

    let type:String

    let difficulty:String

    let question:String

    let correct_answer:String

    let incorrect_answers:[String]




    var answers:[String] {


        var allAnswers =
        incorrect_answers


        allAnswers.append(
            correct_answer
        )


        return allAnswers.shuffled()


    }





    enum CodingKeys:String, CodingKey {


        case category

        case type

        case difficulty

        case question

        case correct_answer

        case incorrect_answers


    }


}
