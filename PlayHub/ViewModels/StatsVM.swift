//
//  StatsVM.swift
//  PlayHub
//

import Foundation
import Combine


@MainActor
final class StatsVM: ObservableObject {


    @Published var sessions:[GameSession] = []

    @Published var totalGames:Int = 0

    @Published var bestScore:Int = 0






    init(){

        load()

    }








    // MARK: Load Data


    func load(){


        guard let player =
                StorageService.shared
                .currentPlayer()

        else {


            sessions = []

            totalGames = 0

            bestScore = 0

            return


        }







        sessions =
        StorageService.shared
            .loadHistory()
            .filter {

                $0.playerName ==
                player.name

            }






        totalGames =
        sessions.count





        bestScore =
        sessions
            .map {

                $0.score

            }
            .max()
        ??
        0



    }









    // MARK: Refresh


    func refresh(){


        load()


    }








}
