//
//  ContentView.swift
//  PlayHub
//

import SwiftUI


struct ContentView: View {


    @EnvironmentObject var vm: PlayerVM



    var body: some View {


        Group {


            if vm.player != nil {


                MainTabView()


            } else {


                PlayerSelectView()


            }


        }


        .onAppear {


            vm.load()


        }


        .onReceive(
            NotificationCenter.default.publisher(
                for: .playerChanged
            )
        ) { _ in


            vm.load()


        }



    }


}




extension Notification.Name {


    static let playerChanged =
    Notification.Name(
        "playerChanged"
    )


}
