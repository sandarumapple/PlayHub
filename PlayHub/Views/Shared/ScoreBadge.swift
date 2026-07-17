//
//  ScoreBadge.swift
//

import SwiftUI


struct ScoreBadge: View {


    var title:String

    var value:Int



    var body: some View {


        VStack(spacing:8){


            Text(title)

                .font(.caption)

                .foregroundStyle(.secondary)



            Text("\(value)")

                .font(.largeTitle)

                .bold()


        }

        .padding()

        .background(

            RoundedRectangle(
                cornerRadius:20
            )

            .fill(.blue.opacity(0.15))

        )

    }
}



#Preview {


    ScoreBadge(
        title:"Score",
        value:100
    )

}
