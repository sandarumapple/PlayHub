//
//  ResultView.swift
//

import SwiftUI



struct ResultView: View {



    var title:String


    var score:Int


    var highScore:Int


    var playAgain:()->Void





    var body: some View {



        VStack(spacing:25){



            Text(title)

                .font(.largeTitle)

                .bold()



            ScoreBadge(
                title:"Final Score",
                value:score
            )



            if score >= highScore {



                Label(
                    "New High Score!",
                    systemImage:"trophy.fill"
                )

                .font(.headline)

                .foregroundStyle(.orange)


            }



            Button{


                playAgain()


            }label:{


                Text("Play Again")


                    .font(.title3)

                    .bold()

                    .frame(
                        maxWidth:.infinity
                    )

                    .padding()

                    .background(.blue)

                    .foregroundStyle(.white)

                    .clipShape(
                        RoundedRectangle(
                            cornerRadius:18
                        )
                    )

            }


        }

        .padding()

    }
}



#Preview {


    ResultView(
        title:"Game Over",
        score:120,
        highScore:100,
        playAgain:{}
    )

}
