//
// StatsTab.swift
// PlayHub
//

import SwiftUI
import Charts


struct StatsTab: View {


    @StateObject private var vm = StatsVM()



    var gamePerformance: [GamePerformance] {


        GameMode.allCases.map { mode in


            let score =
            vm.sessions
                .filter {
                    $0.mode == mode
                }
                .map {
                    $0.score
                }
                .max()
            ?? 0



            return GamePerformance(
                mode: mode,
                score: score
            )

        }

    }






    var body: some View {


        NavigationStack {


            ZStack {


                background



                ScrollView {


                    VStack(spacing:25) {


                        header



                        HStack(spacing:15) {


                            statCard(
                                icon:"gamecontroller.fill",
                                title:"Games",
                                value:
                                    "\(vm.totalGames)"
                            )



                            statCard(
                                icon:"trophy.fill",
                                title:"Best",
                                value:
                                    "\(vm.bestScore)"
                            )

                        }







                        if vm.sessions.isEmpty {


                            emptyState



                        } else {



                            chartCard



                            scoreList



                            NavigationLink {


                                PlayerHistoryView()


                            } label: {


                                Text(
                                    "View Full History"
                                )

                                .font(.headline)

                                .frame(
                                    maxWidth:.infinity
                                )

                                .padding()

                                .background(
                                    Color.blue
                                )

                                .foregroundStyle(
                                    .white
                                )

                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius:18
                                    )
                                )

                            }

                        }


                    }

                    .padding()

                }


            }

            .navigationTitle(
                "Stats"
            )

            .navigationBarTitleDisplayMode(
                .large
            )

        }

        .onAppear {

            vm.load()

        }

    }









    // MARK: Background


    var background: some View {


        LinearGradient(
            colors:[
                Color.black,
                Color.blue.opacity(0.3),
                Color.purple.opacity(0.25)
            ],
            startPoint:.topLeading,
            endPoint:.bottomTrailing
        )

        .ignoresSafeArea()

    }









    // MARK: Header


    var header: some View {


        VStack(
            alignment:.leading,
            spacing:8
        ){


            Text(
                "Performance"
            )

            .font(.largeTitle)
            .bold()
            .foregroundStyle(.white)



            Text(
                "Your gaming progress"
            )

            .foregroundStyle(
                .white.opacity(0.7)
            )


        }

        .frame(
            maxWidth:.infinity,
            alignment:.leading
        )

    }









    // MARK: Stat Card


    func statCard(
        icon:String,
        title:String,
        value:String
    ) -> some View {


        VStack(spacing:10){


            Image(
                systemName:icon
            )

            .font(.title2)

            .foregroundStyle(
                .yellow
            )



            Text(value)

            .font(.title)
            .bold()
            .foregroundStyle(.white)



            Text(title)

            .font(.caption)

            .foregroundStyle(
                .white.opacity(0.7)
            )


        }

        .frame(
            maxWidth:.infinity
        )

        .padding()



        .background(
            .ultraThinMaterial
        )


        .clipShape(
            RoundedRectangle(
                cornerRadius:22
            )
        )


    }









    // MARK: Chart


    var chartCard: some View {


        VStack(
            alignment:.leading,
            spacing:15
        ){


            Text(
                "Highest Scores"
            )

            .font(.title3.bold())
            .foregroundStyle(.white)



            Chart {


                ForEach(
                    gamePerformance
                ){ item in



                    BarMark(

                        x:
                            .value(
                                "Score",
                                item.score
                            ),


                        y:
                            .value(
                                "Game",
                                item.mode.rawValue
                            )

                    )

                    .foregroundStyle(
                        color(
                            for:item.mode
                        )
                    )

                }


            }

            .frame(
                height:220
            )


        }


        .padding()


        .background(
            .ultraThinMaterial
        )

        .clipShape(
            RoundedRectangle(
                cornerRadius:22
            )
        )


    }









    // MARK: Score List


    var scoreList: some View {


        VStack(
            alignment:.leading,
            spacing:15
        ){



            Text(
                "Game Records"
            )

            .font(.title3.bold())
            .foregroundStyle(.white)




            ForEach(
                gamePerformance
            ){ item in



                HStack{


                    Image(
                        systemName:
                            item.mode.icon
                    )

                    .font(.title2)

                    .foregroundStyle(
                        color(
                            for:item.mode
                        )
                    )



                    VStack(
                        alignment:.leading
                    ){


                        Text(
                            item.mode.rawValue
                        )

                        .bold()
                        .foregroundStyle(.white)



                        Text(
                            "Highest Score"
                        )

                        .font(.caption)

                        .foregroundStyle(
                            .white.opacity(0.6)
                        )

                    }



                    Spacer()



                    Text(
                        "\(item.score)"
                    )

                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)



                }


                .padding()


                .background(
                    .ultraThinMaterial
                )

                .clipShape(
                    RoundedRectangle(
                        cornerRadius:18
                    )
                )


            }


        }


    }









    // MARK: Empty


    var emptyState: some View {


        VStack(spacing:15){


            Image(
                systemName:
                    "chart.bar"
            )

            .font(.system(size:60))

            .foregroundStyle(
                .white.opacity(0.6)
            )



            Text(
                "No games played yet"
            )

            .font(.title3.bold())
            .foregroundStyle(.white)



            Text(
                "Start playing to see your stats"
            )

            .foregroundStyle(
                .white.opacity(0.7)
            )


        }

        .padding(40)

        .background(
            .ultraThinMaterial
        )

        .clipShape(
            RoundedRectangle(
                cornerRadius:25
            )
        )


    }









    func color(
        for mode:GameMode
    ) -> Color {


        switch mode {


        case .tapFrenzy:

            return .blue


        case .lightItUp:

            return .orange


        case .quizRush:

            return .green


        }

    }


}






struct GamePerformance: Identifiable {


    let id = UUID()

    let mode: GameMode

    let score: Int

}
