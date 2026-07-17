//
//  AddPlayerView.swift
//  PlayHub
//

import SwiftUI


struct AddPlayerView: View {


    @ObservedObject var vm: PlayerVM


    @Environment(\.dismiss)
    private var dismiss



    @State private var name = ""





    var body: some View {


        NavigationStack {


            VStack(spacing:30) {



                Image(
                    systemName:
                        "person.badge.plus"
                )

                .font(
                    .system(
                        size:70
                    )
                )

                .foregroundStyle(
                    .blue
                )





                Text(
                    "Create Player"
                )

                .font(
                    .largeTitle.bold()
                )







                TextField(
                    "Enter player name",
                    text:$name
                )

                .textFieldStyle(
                    .roundedBorder
                )

                .padding(
                    .horizontal
                )







                Button {



                    createPlayer()



                } label:{



                    HStack {



                        Image(
                            systemName:
                                "plus.circle.fill"
                        )



                        Text(
                            "Create Player"
                        )

                        .bold()



                    }


                    .frame(
                        maxWidth:.infinity
                    )


                    .padding()


                    .background(
                        name.isEmpty
                        ?
                        Color.gray
                        :
                        Color.blue
                    )


                    .foregroundStyle(
                        .white
                    )


                    .clipShape(
                        RoundedRectangle(
                            cornerRadius:20
                        )
                    )


                }


                .disabled(
                    name.trimmingCharacters(
                        in:.whitespaces
                    )
                    .isEmpty
                )


                .padding(
                    .horizontal
                )







                Spacer()



            }

            .padding()



            .navigationTitle(
                "New Player"
            )

            .navigationBarTitleDisplayMode(
                .inline
            )



        }



    }









    private func createPlayer(){



        let cleanName =
        name.trimmingCharacters(
            in:.whitespaces
        )



        guard !cleanName.isEmpty
        else {
            return
        }






        vm.addPlayer(
            name:cleanName
        )






        NotificationCenter.default
            .post(
                name:
                    .playerChanged,
                object:nil
            )






        dismiss()



    }



}







#Preview {


    AddPlayerView(
        vm:
            PlayerVM()
    )


}
