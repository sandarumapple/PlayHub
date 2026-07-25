//
// TriviaAPI.swift
// PlayHub
//

import Foundation



final class TriviaAPI {



    static let shared =
    TriviaAPI()



    private init(){}






    func fetchQuestions(
        difficulty: GameDifficulty,
        amount: Int
    )
    async throws
    -> [TriviaQuestion] {



        guard let url =
                URL(
                    string:
                    "https://opentdb.com/api.php?amount=\(amount)&difficulty=\(difficulty.apiValue)&type=multiple"
                )

        else {

            throw URLError(
                .badURL
            )

        }





        let (data, _) =
        try await URLSession.shared
            .data(
                from:url
            )





        let decoder =
        JSONDecoder()





        let response =
        try decoder.decode(
            TriviaResponse.self,
            from:data
        )






        if response.response_code != 0 {


            throw URLError(
                .cannotParseResponse
            )

        }






        return response.results



    }



}
