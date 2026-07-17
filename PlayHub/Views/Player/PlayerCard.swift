
//
// PlayerCard.swift
//

import SwiftUI


struct PlayerCard: View {


    let player:Player



    var body: some View {



        HStack(spacing:20){



            Image(systemName:"person.circle.fill")

                .font(.system(size:55))

                .foregroundStyle(.blue)




            VStack(alignment:.leading){


                Text(player.name)

                    .font(.title2)

                    .bold()



                Text(
                    "Games Played: \(player.totalGames)"
                )


                Text(
                    "Best Score: \(player.bestScore)"
                )


            }


        }

        .padding()

        .background(

            RoundedRectangle(
                cornerRadius:20
            )

            .fill(.gray.opacity(0.15))

        )

    }
}



#Preview {


    PlayerCard(
        player:
            Player(
                name:"Sandaru"
            )
    )

}
