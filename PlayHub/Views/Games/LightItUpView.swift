//
//  LightItUpView.swift
//  PlayHub
//

import SwiftUI


struct LightItUpView: View {


    @StateObject private var vm =
    LightItUpVM()



    @State private var animate =
    false





    var body: some View {


        ZStack {



            background



            VStack(spacing:20) {



                header





                if vm.gameStarted {



                    gameGrid



                }
                else {



                    startScreen



                }



            }

            .padding()



        }



        .navigationTitle(
            "Light It Up"
        )

        .navigationBarTitleDisplayMode(
            .inline
        )



        .alert(
            "Game Finished 🔥",
            isPresented: $vm.gameOver
        ) {

            Button("Play Again") {

                vm.startGame()

            }


            Button(
                "Done",
                role: .cancel
            ) {

            }


        } message: {

            Text(
                """
                Score: \(vm.score)

                High Score: \(vm.highScore)
                """
            )

        }



        
       


    }







    // MARK: Background


    var background: some View {


        LinearGradient(

            colors:[

                Color.black,

                Color.green.opacity(0.25),

                Color.black

            ],

            startPoint:.topLeading,

            endPoint:.bottomTrailing

        )

        .ignoresSafeArea()


    }









    // MARK: Header


    var header: some View {


        VStack(spacing:15) {



            Text("💡 Light It Up")

                .font(.largeTitle)

                .bold()

                .foregroundStyle(
                    .white
                )







            HStack(spacing:12) {



                statCard(
                    icon:"bolt.fill",
                    title:"Score",
                    value:
                        "\(vm.score)"
                )



                statCard(
                    icon:"timer",
                    title:"Time",
                    value:
                        "\(vm.timeRemaining)"
                )



                statCard(
                    icon:
                        "chart.line.uptrend.xyaxis",
                    title:"Level",
                    value:
                        "\(vm.currentLevel)"
                )



            }






            HStack {



                Image(
                    systemName:
                        "trophy.fill"
                )

                .foregroundStyle(
                    .yellow
                )



                Text(
                    "Best \(vm.highScore)"
                )

                .foregroundStyle(
                    .white
                )



                Spacer()



            }

            .padding()

            .background(
                .ultraThinMaterial
            )

            .clipShape(
                RoundedRectangle(
                    cornerRadius:20
                )
            )



        }



    }










    func statCard(
        icon:String,
        title:String,
        value:String
    ) -> some View {



        VStack(spacing:8) {



            Image(
                systemName:icon
            )

            .foregroundStyle(
                .green
            )



            Text(value)

                .font(.title3)

                .bold()

                .foregroundStyle(
                    .white
                )



            Text(title)

                .font(.caption)

                .foregroundStyle(
                    .gray
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
                cornerRadius:18
            )
        )


    }










    // MARK: Start Screen


    var startScreen: some View {


        VStack(spacing:30) {



            Spacer()





            ZStack {



                Circle()

                    .fill(
                        Color.green.opacity(0.25)
                    )

                    .frame(
                        width:180,
                        height:180
                    )


                    .scaleEffect(
                        animate ? 1.15 : 1
                    )


                    .animation(

                        .easeInOut(
                            duration:1
                        )
                        .repeatForever(),

                        value:animate

                    )






                Text("💡")

                    .font(
                        .system(
                            size:90
                        )
                    )



            }






            Text(
                "Tap the glowing light\nbefore it disappears"
            )

            .multilineTextAlignment(
                .center
            )

            .font(.title3)

            .foregroundStyle(
                .white
            )







            Button {



                vm.startGame()



            } label:{



                HStack {



                    Image(
                        systemName:
                            "play.fill"
                    )



                    Text(
                        "START GAME"
                    )



                }


                .font(.headline)

                .foregroundStyle(
                    .black
                )

                .padding()

                .frame(
                    maxWidth:.infinity
                )

                .background(
                    Color.green
                )

                .clipShape(
                    RoundedRectangle(
                        cornerRadius:20
                    )
                )



            }

            .padding(
                .horizontal,
                30
            )





            Spacer()



        }


        .onAppear {


            animate = true


        }



    }









    // MARK: Game Grid


    var gameGrid: some View {



        LazyVGrid(

            columns:
                Array(

                    repeating:
                        GridItem(.flexible()),

                    count:
                        vm.columnCount

                ),


            spacing:18


        ) {



            ForEach(

                0..<vm.cardCount,

                id:\.self

            ){ index in






                RoundedRectangle(
                    cornerRadius:20
                )

                .fill(

                    cardStyle(
                        active:
                            vm.activeCards.contains(index)
                    )

                )



                .frame(
                    height:95
                )



                .overlay {



                    if vm.activeCards.contains(index) {



                        Text("TAP!")

                            .font(.title2)

                            .bold()

                            .foregroundStyle(
                                .white
                            )


                    }



                }



                .shadow(

                    color:

                        vm.activeCards.contains(index)

                        ?

                        Color.green

                        :

                        Color.clear,


                    radius:20

                )



                .scaleEffect(

                    vm.activeCards.contains(index)

                    ?

                    1.08

                    :

                    1

                )



                .animation(

                    .spring(),

                    value:
                        vm.activeCards

                )



                .onTapGesture {



                    vm.tapCard(index)



                }





            }



        }

        .padding()



    }








    // MARK: Card Style Fix


    func cardStyle(
        active:Bool
    ) -> AnyShapeStyle {



        if active {



            return AnyShapeStyle(

                LinearGradient(

                    colors:[

                        Color.green,

                        Color.mint

                    ],

                    startPoint:.top,

                    endPoint:.bottom

                )

            )



        }
        else {



            return AnyShapeStyle(

                Color.white.opacity(0.12)

            )


        }


    }



}







#Preview {



    NavigationStack {



        LightItUpView()



    }


}
