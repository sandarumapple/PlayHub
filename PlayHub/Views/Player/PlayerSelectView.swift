//
//  PlayerSelectView.swift
//  PlayHub
//

import SwiftUI


struct PlayerSelectView: View {


    @StateObject private var vm = PlayerVM()


    @State private var showAddPlayer = false


    @State private var showDeleteAlert = false


    @State private var selectedDeletePlayer: Player?






    var body: some View {


        NavigationStack {


            VStack(spacing:25) {


                header



                if vm.players.isEmpty {


                    emptyView



                } else {



                    playerList



                }



                addButton



            }

            .padding()



            .navigationTitle(
                "Select Player"
            )



            .sheet(
                isPresented:
                    $showAddPlayer
            ) {



                AddPlayerView(
                    vm: vm
                )



            }



            .alert(
                "Delete Player?",
                isPresented:
                    $showDeleteAlert
            ) {



                Button(
                    "Cancel",
                    role:.cancel
                ){}



                Button(
                    "Delete",
                    role:.destructive
                ){



                    if let player =
                        selectedDeletePlayer {



                        vm.deletePlayer(
                            player
                        )


                    }


                }



            } message:{



                Text(
                    "This player will be removed permanently."
                )



            }



            .onAppear {


                vm.load()


            }



        }



    }









    // MARK: Header


    private var header: some View {


        VStack(spacing:10) {



            Image(
                systemName:
                    "person.3.fill"
            )

            .font(
                .system(
                    size:60
                )
            )

            .foregroundStyle(
                .blue
            )




            Text(
                "Choose Player"
            )

            .font(
                .largeTitle.bold()
            )




            Text(
                "Select existing player or create new one"
            )

            .foregroundStyle(
                .secondary
            )



        }


    }









    // MARK: Player List


    private var playerList: some View {


        ScrollView {


            VStack(
                spacing:15
            ){



                ForEach(
                    vm.players,
                    id:\.id
                ){ player in



                    HStack {



                        Image(
                            systemName:
                                "person.circle.fill"
                        )

                        .font(
                            .system(
                                size:45
                            )
                        )

                        .foregroundStyle(
                            .blue
                        )




                        VStack(
                            alignment:.leading
                        ){


                            Text(
                                player.name
                            )

                            .font(
                                .title3.bold()
                            )



                            Text(
                                "Games: \(player.totalGames)"
                            )

                            .font(
                                .caption
                            )



                            Text(
                                "Best Score: \(player.bestScore)"
                            )

                            .font(
                                .caption
                            )



                        }





                        Spacer()





                        if vm.player?.id == player.id {


                            Image(
                                systemName:
                                    "checkmark.circle.fill"
                            )

                            .foregroundStyle(
                                .green
                            )


                        }



                    }


                    .padding()



                    .background(

                        RoundedRectangle(
                            cornerRadius:20
                        )

                        .fill(
                            Color.gray.opacity(0.12)
                        )


                    )



                    .onTapGesture {



                        vm.selectPlayer(
                            player
                        )



                    }



                    .contextMenu {



                        Button(
                            role:.destructive
                        ){



                            selectedDeletePlayer =
                                player



                            showDeleteAlert = true



                        } label:{



                            Label(
                                "Delete",
                                systemImage:
                                    "trash"
                            )



                        }



                    }



                }



            }



        }



    }









    // MARK: Empty


    private var emptyView: some View {


        VStack(spacing:15){


            Image(
                systemName:
                    "person.crop.circle.badge.questionmark"
            )

            .font(
                .largeTitle
            )

            .foregroundStyle(
                .secondary
            )



            Text(
                "No Players"
            )

            .font(
                .title3.bold()
            )



        }

        .padding()



    }









    // MARK: Add Button


    private var addButton: some View {


        Button {


            showAddPlayer = true



        } label:{



            HStack {


                Image(
                    systemName:
                        "person.badge.plus"
                )


                Text(
                    "Add New Player"
                )

                .bold()



            }


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
                    cornerRadius:20
                )
            )



        }



    }



}







#Preview {


    PlayerSelectView()


}
