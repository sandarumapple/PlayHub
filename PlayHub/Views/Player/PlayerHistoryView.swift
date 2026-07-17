//
// PlayerHistoryView.swift
//

import SwiftUI



struct PlayerHistoryView: View {



    @StateObject private var vm =
    StatsVM()



    var body: some View {



        NavigationStack{


            List(vm.sessions){ session in



                VStack(
                    alignment:.leading,
                    spacing:6
                ){



                    Text(
                        session.mode.rawValue
                    )

                    .font(.headline)




                    Text(
                        "Score: \(session.score)"
                    )



                    Text(
                        session.date
                            .formatted()
                    )

                    .font(.caption)

                    .foregroundStyle(
                        .secondary
                    )


                }


            }

            .navigationTitle(
                "Game History"
            )

        }

    }
}
