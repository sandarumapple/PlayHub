//
// HomeTab.swift
// PlayHub
//

import SwiftUI


struct HomeTab: View {


    @AppStorage("playerName")
    private var playerName = ""


    @StateObject private var playerVM = PlayerVM()



    var body: some View {


        NavigationStack {


            ZStack {


                homeBackground



                ScrollView {


                    VStack(
                        spacing:25
                    ) {


                        header



                        playerCard



                        Text(
                            "Choose Your Challenge"
                        )

                        .font(
                            .title2
                        )

                        .bold()

                        .foregroundStyle(
                            .white
                        )

                        .frame(
                            maxWidth:.infinity,
                            alignment:.leading
                        )







                        gameCard(
                            title:"Tap Frenzy",
                            subtitle:"Tap fast and build combos",
                            icon:"hand.tap.fill",
                            colors:[
                                .blue,
                                .cyan
                            ]
                        ){

                            TapFrenzyView()

                        }







                        gameCard(
                            title:"Light It Up",
                            subtitle:"Catch the glowing lights",
                            icon:"lightbulb.fill",
                            colors:[
                                .yellow,
                                .orange
                            ]
                        ){

                            LightItUpView()

                        }








                        gameCard(
                            title:"Quiz Rush",
                            subtitle:"Test your knowledge",
                            icon:"questionmark.circle.fill",
                            colors:[
                                .purple,
                                .pink
                            ]
                        ){

                            QuizRushView()

                        }




                    }

                    .padding()



                }



            }



            .navigationTitle(
                "PlayHub"
            )

            .navigationBarTitleDisplayMode(
                .large
            )



            .onAppear {


                playerVM.refresh()


            }



        }


    }









    // MARK: BACKGROUND


    private var homeBackground: some View {


        ZStack {



            LinearGradient(

                colors:[

                    Color.black,


                    Color(
                        red:0.02,
                        green:0.14,
                        blue:0.12
                    ),


                    Color(
                        red:0.04,
                        green:0.04,
                        blue:0.18
                    )


                ],

                startPoint:.topLeading,

                endPoint:.bottomTrailing

            )








            Circle()

                .fill(
                    Color.mint.opacity(0.28)
                )

                .frame(
                    width:330,
                    height:330
                )

                .blur(
                    radius:120
                )

                .offset(
                    x:-160,
                    y:-300
                )









            Circle()

                .fill(
                    Color.blue.opacity(0.22)
                )

                .frame(
                    width:300,
                    height:300
                )

                .blur(
                    radius:120
                )

                .offset(
                    x:160,
                    y:300
                )








            Circle()

                .fill(
                    Color.purple.opacity(0.15)
                )

                .frame(
                    width:220,
                    height:220
                )

                .blur(
                    radius:100
                )

                .offset(
                    x:0,
                    y:-50
                )



        }

        .ignoresSafeArea()



    }









    // MARK: HEADER


    private var header: some View {


        VStack(
            alignment:.leading,
            spacing:10
        ){


            Text(
                "🎮 Welcome Back"
            )

            .font(
                .largeTitle
            )

            .bold()

            .foregroundStyle(
                .white
            )







            Text(
                playerName.isEmpty
                ?
                "Ready to play?"
                :
                playerName
            )

            .font(
                .title3
            )

            .foregroundStyle(
                .white.opacity(0.75)
            )



        }

        .frame(
            maxWidth:.infinity,
            alignment:.leading
        )


    }









    // MARK: PLAYER CARD


    private var playerCard: some View {


        HStack {


            Image(
                systemName:
                    "trophy.fill"
            )

            .font(
                .largeTitle
            )

            .foregroundStyle(
                .yellow
            )







            VStack(
                alignment:.leading
            ){


                Text(
                    "Best Score"
                )

                .foregroundStyle(
                    .white.opacity(0.7)
                )




                Text(
                    "\(playerVM.player?.bestScore ?? 0)"
                )

                .font(
                    .title
                )

                .bold()

                .foregroundStyle(
                    .white
                )



            }




            Spacer()





            VStack(
                alignment:.trailing
            ){



                Text(
                    "Games"
                )

                .foregroundStyle(
                    .white.opacity(0.7)
                )





                Text(
                    "\(playerVM.player?.totalGames ?? 0)"
                )

                .font(
                    .title
                )

                .bold()

                .foregroundStyle(
                    .white
                )



            }





        }

        .padding()



        .background(
            Color.white.opacity(0.10)
        )


        .clipShape(
            RoundedRectangle(
                cornerRadius:25
            )
        )


        .overlay(

            RoundedRectangle(
                cornerRadius:25
            )

            .stroke(
                Color.mint.opacity(0.35),
                lineWidth:1
            )

        )



    }









    // MARK: GAME CARD


    private func gameCard<Content:View>(
        title:String,
        subtitle:String,
        icon:String,
        colors:[Color],
        destination:@escaping () -> Content
    ) -> some View {


        NavigationLink {


            destination()


        } label:{


            HStack(
                spacing:18
            ){



                Image(
                    systemName:icon
                )

                .font(
                    .system(
                        size:35
                    )
                )

                .foregroundStyle(
                    .white
                )






                VStack(
                    alignment:.leading,
                    spacing:5
                ){



                    Text(
                        title
                    )

                    .font(
                        .title3
                    )

                    .bold()

                    .foregroundStyle(
                        .white
                    )





                    Text(
                        subtitle
                    )

                    .font(
                        .caption
                    )

                    .foregroundStyle(
                        .white.opacity(0.8)
                    )



                }






                Spacer()






                Image(
                    systemName:
                        "chevron.right"
                )

                .foregroundStyle(
                    .white
                )



            }


            .padding()



            .background(

                LinearGradient(
                    colors:colors,
                    startPoint:.leading,
                    endPoint:.trailing
                )

            )


            .clipShape(

                RoundedRectangle(
                    cornerRadius:25
                )

            )


            .shadow(
                radius:10
            )


        }


    }



}
