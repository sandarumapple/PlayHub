//
// GameCard.swift
//

import SwiftUI


struct GameCard<Destination:View>: View {


    let title:String

    let icon:String

    let color:Color

    let destination:()->Destination



    init(
        title:String,
        icon:String,
        color:Color,
        @ViewBuilder destination:@escaping ()->Destination
    ){

        self.title = title
        self.icon = icon
        self.color = color
        self.destination = destination

    }



    var body: some View {


        NavigationLink {


            destination()


        } label:{


            HStack {


                Image(systemName:icon)
                    .font(.largeTitle)



                Text(title)
                    .font(.title2)
                    .bold()



                Spacer()


                Image(systemName:"chevron.right")


            }
            .padding()
            .frame(maxWidth:.infinity)
            .background(color.opacity(0.25))
            .clipShape(
                RoundedRectangle(
                    cornerRadius:20
                )
            )


        }


    }

}
