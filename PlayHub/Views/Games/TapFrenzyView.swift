//
// TapFrenzyView.swift
// PlayHub
//

import SwiftUI



struct TapFrenzyView: View {


    @StateObject private var vm =
    TapFrenzyVM()



    @State private var buttonSize: CGFloat = 170


    @State private var buttonPosition =
    CGSize.zero



    @State private var pulse = false





    var body: some View {



        ZStack {



            background






            VStack(spacing:25) {



                header






                if vm.gameOver {



                    ResultView(

                        title:"Tap Frenzy",

                        score:
                            vm.score,

                        highScore:
                            vm.highScore

                    ) {


                        resetGame()

                    }




                }

                else {



                    Spacer()





                    tapButton





                    Spacer()





                    comboArea



                }



            }

            .padding()



        }

        .navigationTitle(
            "Tap Frenzy"
        )

        .navigationBarTitleDisplayMode(
            .inline
        )





        .onAppear {


            if !vm.isStarted {


                vm.start()


            }


        }



    }










    // MARK: Header


    var header: some View {



        VStack(spacing:15) {



            Text(
                "⚡ Tap Frenzy"
            )

            .font(
                .largeTitle
            )

            .bold()

            .foregroundStyle(
                .white
            )








            HStack(spacing:15) {



                gameCard(
                    icon:"hand.tap.fill",
                    title:"Score",
                    value:
                        "\(vm.score)"
                )



                gameCard(
                    icon:"timer",
                    title:"Time",
                    value:
                        "\(vm.time)"
                )



            }




        }



    }









    func gameCard(
        icon:String,
        title:String,
        value:String
    ) -> some View {



        VStack(spacing:8) {



            Image(
                systemName:icon
            )

            .foregroundStyle(
                .cyan
            )



            Text(value)

                .font(.title2)

                .bold()

                .foregroundStyle(
                    .white
                )



            Text(title)

                .font(.caption)

                .foregroundStyle(
                    .white.opacity(0.6)
                )



        }

        .frame(
            width:140
        )

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









    // MARK: Tap Button


    var tapButton: some View {



        Button {



            vm.tap()


            moveButton()


            shrinkButton()



        } label:{



            Text(
                "TAP"
            )

            .font(
                .largeTitle
            )

            .bold()

            .foregroundStyle(
                .white
            )

            .frame(
                width:buttonSize,
                height:buttonSize
            )

            .background(


                LinearGradient(

                    colors:[

                        Color.cyan,

                        Color.green

                    ],

                    startPoint:
                        .topLeading,

                    endPoint:
                        .bottomTrailing

                )


            )


            .clipShape(
                Circle()
            )



            .shadow(
                color:
                    .cyan.opacity(0.8),

                radius:
                    pulse ? 35 : 15
            )



            .scaleEffect(
                pulse ? 1.05 : 1
            )


            .animation(
                .easeInOut(
                    duration:1
                )
                .repeatForever(),

                value:pulse
            )



        }


        .offset(
            buttonPosition
        )

        .onAppear{


            pulse = true


        }



    }










    // MARK: Combo


    var comboArea: some View {



        VStack(spacing:15) {



            Text(
                "Combo ×\(vm.combo)"
            )

            .font(
                .title2
            )

            .bold()

            .foregroundStyle(
                .white
            )







            if vm.doublePoints {



                Text(
                    "🔥 DOUBLE POINTS!"
                )

                .font(
                    .headline
                )

                .foregroundStyle(
                    .orange
                )


            }






            Button {


                vm.activateDoublePoints()



            } label:{



                Text(
                    "Bonus Burst ⚡"
                )

                .bold()



            }

            .buttonStyle(
                .borderedProminent
            )

            .tint(
                .green
            )




        }



        .padding()

        .background(
            .ultraThinMaterial
        )

        .clipShape(
            RoundedRectangle(
                cornerRadius:25
            )
        )



    }










    func resetGame(){


        buttonSize = 170


        buttonPosition =
        .zero



        vm.restart()


    }









    func moveButton(){


        withAnimation(
            .spring()
        ){



            buttonPosition = CGSize(

                width:
                    CGFloat.random(
                        in:-120...120
                    ),


                height:
                    CGFloat.random(
                        in:-180...180
                    )

            )


        }


    }









    func shrinkButton(){



        if buttonSize > 80 {


            withAnimation {


                buttonSize -= 5


            }


        }



    }









    // MARK: Background


    var background: some View {



        ZStack {



            LinearGradient(

                colors:[


                    Color.black,


                    Color(
                        red:0.02,
                        green:0.12,
                        blue:0.18
                    ),



                    Color(
                        red:0.08,
                        green:0.02,
                        blue:0.18
                    )


                ],

                startPoint:.topLeading,

                endPoint:.bottomTrailing

            )







            Circle()

                .fill(
                    Color.cyan.opacity(0.22)
                )

                .blur(
                    radius:90
                )

                .offset(
                    x:-120,
                    y:-250
                )








            Circle()

                .fill(
                    Color.green.opacity(0.20)
                )

                .blur(
                    radius:100
                )

                .offset(
                    x:150,
                    y:300
                )



        }

        .ignoresSafeArea()



    }


}





#Preview {


    NavigationStack {


        TapFrenzyView()


    }


}
