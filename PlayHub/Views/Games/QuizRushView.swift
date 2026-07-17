//
// QuizRushView.swift
// PlayHub
//

import SwiftUI



struct QuizRushView: View {



    @StateObject private var vm =
    QuizRushVM()






    var body: some View {



        ZStack {



            background





            VStack(spacing:20){



                switch vm.state {



                case .loading:



                    loadingView







                case .failed(let message):



                    errorView(
                        message: message
                    )








                case .playing:



                    playingView()







                case .finished:



                    ResultView(

                        title:"Quiz Rush",

                        score:
                            vm.score,

                        highScore:
                            vm.highScore

                    ){



                        Task {


                            await vm.load()


                        }



                    }




                }





            }

            .padding()



        }



        .navigationTitle(
            "Quiz Rush"
        )

        .navigationBarTitleDisplayMode(
            .inline
        )



    }









    // MARK: Loading


    var loadingView: some View {



        VStack(spacing:25){



            ProgressView()

                .scaleEffect(
                    1.5
                )

                .tint(
                    .cyan
                )




            Text(
                "Loading Questions..."
            )

            .foregroundStyle(
                .white
            )

            .font(
                .title3
            )



        }

        .task {


            await vm.load()


        }



    }









    // MARK: Error


    func errorView(
        message:String
    )->some View {



        VStack(spacing:25){



            Text(
                "⚠️"
            )

            .font(
                .system(
                    size:70
                )
            )





            Text(
                "Quiz Error"
            )

            .font(
                .largeTitle
            )

            .bold()

            .foregroundStyle(
                .white
            )






            Text(message)

            .multilineTextAlignment(
                .center
            )

            .foregroundStyle(
                .white.opacity(0.7)
            )








            Button {



                vm.retry()



            } label:{



                Text(
                    "Retry"
                )

                .bold()

                .frame(
                    width:150
                )

                .padding()

                .background(
                    Color.cyan
                )

                .foregroundStyle(
                    .black
                )

                .clipShape(
                    RoundedRectangle(
                        cornerRadius:18
                    )
                )


            }



        }


    }









    // MARK: Playing


    @ViewBuilder
    func playingView()
    -> some View {



        VStack(spacing:20){







            HStack(spacing:15){



                statCard(

                    icon:"star.fill",

                    title:"Score",

                    value:
                        "\(vm.score)"

                )





                statCard(

                    icon:"flame.fill",

                    title:"Streak",

                    value:
                        "\(vm.streak)"

                )




            }








            Text(

                "\(vm.currentIndex + 1) / \(vm.questions.count)"

            )

            .font(
                .headline
            )

            .foregroundStyle(
                .cyan
            )









            if let question =
                vm.currentQuestion {



                VStack(spacing:20){



                    Text(
                        decode(
                            question.question
                        )
                    )

                    .font(
                        .title3
                    )

                    .bold()

                    .multilineTextAlignment(
                        .center
                    )

                    .foregroundStyle(
                        .white
                    )

                    .padding()




                }

                .background(
                    .ultraThinMaterial
                )

                .clipShape(
                    RoundedRectangle(
                        cornerRadius:25
                    )
                )










                ForEach(
                    question.answers,
                    id:\.self
                ){ answer in




                    Button {



                        vm.choose(
                            answer:answer
                        )



                    } label:{



                        Text(
                            decode(answer)
                        )

                        .frame(
                            maxWidth:.infinity
                        )

                        .padding()



                    }


                    .foregroundStyle(
                        .white
                    )


                    .background(

                        RoundedRectangle(
                            cornerRadius:18
                        )

                        .fill(

                            LinearGradient(

                                colors:[

                                    Color.cyan.opacity(0.35),

                                    Color.purple.opacity(0.35)

                                ],

                                startPoint:
                                    .topLeading,

                                endPoint:
                                    .bottomTrailing

                            )

                        )


                    )


                }





            }



            Spacer()



        }



    }









    func statCard(
        icon:String,
        title:String,
        value:String
    )->some View {



        VStack(spacing:8){



            Image(
                systemName:icon
            )

            .foregroundStyle(
                .yellow
            )



            Text(value)

            .font(
                .title2
            )

            .bold()

            .foregroundStyle(
                .white
            )



            Text(title)

            .font(
                .caption
            )

            .foregroundStyle(
                .white.opacity(0.6)
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
                cornerRadius:20
            )
        )



    }









    // MARK: Background


    var background: some View {



        ZStack {



            LinearGradient(

                colors:[


                    Color.black,


                    Color(
                        red:0.05,
                        green:0.05,
                        blue:0.18
                    ),



                    Color(
                        red:0.18,
                        green:0.03,
                        blue:0.20
                    )

                ],

                startPoint:.topLeading,

                endPoint:.bottomTrailing

            )








            Circle()

                .fill(
                    Color.purple.opacity(0.25)
                )

                .blur(
                    radius:100
                )

                .offset(
                    x:-130,
                    y:-250
                )









            Circle()

                .fill(
                    Color.cyan.opacity(0.20)
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









    func decode(
        _ text:String
    )->String {


        text

            .replacingOccurrences(
                of:"&quot;",
                with:"\""
            )

            .replacingOccurrences(
                of:"&#039;",
                with:"'"
            )

            .replacingOccurrences(
                of:"&amp;",
                with:"&"
            )


    }



}







#Preview {


    NavigationStack {


        QuizRushView()


    }


}
