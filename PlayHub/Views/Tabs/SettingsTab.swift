//
// SettingsTab.swift
// PlayHub
//

import SwiftUI


struct SettingsTab: View {


    @EnvironmentObject var vm: PlayerVM


    @State private var showAddPlayer = false

    @State private var showHistoryAlert = false

    @State private var showDeleteAlert = false

    @State private var showLogoutAlert = false




    var body: some View {


        NavigationStack {


            ZStack {


                background



                ScrollView {


                    VStack(
                        spacing: 30
                    ) {


                        currentPlayerSection


                        playersSection


                        dataSection


                        aboutSection


                    }

                    .padding(.horizontal,20)
                    .padding(.top,10)



                }



            }



            .navigationTitle(
                "Settings"
            )


            .navigationBarTitleDisplayMode(
                .large
            )




            .sheet(
                isPresented:$showAddPlayer
            ) {


                AddPlayerView(
                    vm:vm
                )


            }



            .onAppear {


                vm.refresh()


            }




            .onReceive(
                NotificationCenter.default.publisher(
                    for:.gameSaved
                )
            ){ _ in


                vm.refresh()


            }




            .onReceive(
                NotificationCenter.default.publisher(
                    for:.playerUpdated
                )
            ){ _ in


                vm.refresh()


            }






            .alert(
                "Logout?",
                isPresented:$showLogoutAlert
            ){


                Button(
                    "Cancel",
                    role:.cancel
                ){}




                Button(
                    "Logout",
                    role:.destructive
                ){


                    vm.logout()


                }


            }





            .alert(
                "Clear History?",
                isPresented:$showHistoryAlert
            ){


                Button(
                    "Cancel",
                    role:.cancel
                ){}




                Button(
                    "Clear",
                    role:.destructive
                ){


                    StorageService.shared
                        .clearHistory()


                    vm.refresh()


                }



            } message:{


                Text(
                    "All game history will be removed."
                )


            }







            .alert(
                "Delete All Data?",
                isPresented:$showDeleteAlert
            ){



                Button(
                    "Cancel",
                    role:.cancel
                ){}





                Button(
                    "Delete",
                    role:.destructive
                ){


                    StorageService.shared
                        .clearAllData()


                    vm.refresh()


                }



            } message:{


                Text(
                    "Players, scores and history will be deleted."
                )


            }




        }


    }    // MARK: CURRENT PLAYER
    
    
    private var currentPlayerSection: some View {


        VStack(
            alignment:.leading,
            spacing:15
        ) {


            sectionTitle(
                "Current Player",
                icon:"person.fill"
            )



            if let player = vm.player {


                VStack(
                    alignment:.leading,
                    spacing:15
                ) {


                    HStack(
                        spacing:15
                    ) {


                        Circle()

                            .fill(
                                LinearGradient(
                                    colors:[
                                        .green,
                                        .cyan
                                    ],
                                    startPoint:.topLeading,
                                    endPoint:.bottomTrailing
                                )
                            )

                            .frame(
                                width:65,
                                height:65
                            )


                            .overlay {


                                Image(
                                    systemName:
                                        "person.fill"
                                )

                                .font(
                                    .title
                                )

                                .foregroundStyle(
                                    .white
                                )


                            }




                        VStack(
                            alignment:.leading,
                            spacing:5
                        ) {



                            Text(
                                player.name
                            )

                            .font(
                                .title2
                            )

                            .bold()

                            .foregroundStyle(
                                .white
                            )





                            Text(
                                "🏆 Best Score  \(player.bestScore)"
                            )

                            .font(
                                .subheadline
                            )

                            .foregroundStyle(
                                .yellow
                            )




                            Text(
                                "🎮 Games Played \(player.totalGames)"
                            )

                            .font(
                                .caption
                            )

                            .foregroundStyle(
                                .white.opacity(0.65)
                            )



                        }


                    }







                    if let location = player.locationName {


                        Label(
                            location,
                            systemImage:"location.fill"
                        )

                        .font(
                            .caption
                        )

                        .foregroundStyle(
                            .mint
                        )



                    }
                    else {


                        Label(
                            "Location not saved",
                            systemImage:"location.slash"
                        )

                        .font(
                            .caption
                        )

                        .foregroundStyle(
                            .gray
                        )



                    }







                    Button {


                        showLogoutAlert = true


                    } label:{



                        Label(
                            "Logout",
                            systemImage:
                                "rectangle.portrait.and.arrow.right"
                        )


                    }

                    .foregroundStyle(
                        .red
                    )




                }


                .padding(.vertical,10)




            }
            else {


                Text(
                    "No player selected"
                )

                .foregroundStyle(
                    .gray
                )


            }


        }


    }









    // MARK: PLAYERS


    private var playersSection: some View {


        VStack(
            alignment:.leading,
            spacing:15
        ) {


            sectionTitle(
                "Players",
                icon:"person.3.fill"
            )




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


                    Spacer()



                    Image(
                        systemName:
                            "chevron.right"
                    )


                }

                .foregroundStyle(
                    .mint
                )


            }







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
                        .title2
                    )

                    .foregroundStyle(
                        .cyan
                    )





                    VStack(
                        alignment:.leading
                    ){


                        Text(
                            player.name
                        )

                        .bold()

                        .foregroundStyle(
                            .white
                        )





                        Text(
                            "Best Score: \(player.bestScore)"
                        )

                        .font(
                            .caption
                        )

                        .foregroundStyle(
                            .white.opacity(0.6)
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


                .padding(.vertical,8)



                .contentShape(
                    Rectangle()
                )



                .onTapGesture {


                    vm.selectPlayer(
                        player
                    )


                }



            }



        }


    }    // MARK: DATA
    
    
    private var dataSection: some View {


        VStack(
            alignment:.leading,
            spacing:15
        ) {


            sectionTitle(
                "Data",
                icon:"externaldrive.fill"
            )





            Button {


                showHistoryAlert = true


            } label:{



                HStack {


                    Image(
                        systemName:
                            "trash"
                    )

                    Text(
                        "Clear Game History"
                    )


                    Spacer()



                    Image(
                        systemName:
                            "chevron.right"
                    )


                }

                .foregroundStyle(
                    .orange
                )



            }







            Button {


                showDeleteAlert = true


            } label:{



                HStack {


                    Image(
                        systemName:
                            "trash.fill"
                    )


                    Text(
                        "Delete All Data"
                    )


                    Spacer()



                    Image(
                        systemName:
                            "chevron.right"
                    )


                }

                .foregroundStyle(
                    .red
                )



            }





        }



    }









    // MARK: ABOUT


    private var aboutSection: some View {


        VStack(
            alignment:.leading,
            spacing:15
        ){



            sectionTitle(
                "About",
                icon:"info.circle.fill"
            )




            HStack {


                Text(
                    "App"
                )

                Spacer()


                Text(
                    "PlayHub"
                )

                .foregroundStyle(
                    .mint
                )



            }

            .foregroundStyle(
                .white
            )







            HStack {


                Text(
                    "Version"
                )

                Spacer()



                Text(
                    "1.0"
                )

                .foregroundStyle(
                    .mint
                )



            }

            .foregroundStyle(
                .white
            )






            Text(
                "Play • Compete • Improve"
            )

            .font(
                .caption
            )

            .foregroundStyle(
                .white.opacity(0.6)
            )



        }



    }









    // MARK: SECTION TITLE


    private func sectionTitle(
        _ title:String,
        icon:String
    ) -> some View {


        HStack {


            Image(
                systemName:icon
            )

            .foregroundStyle(
                .mint
            )



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



        }


    }









    // MARK: BACKGROUND


    private var background: some View {


        ZStack {


            LinearGradient(

                colors:[

                    Color.black,

                    Color(
                        red:0.02,
                        green:0.12,
                        blue:0.10
                    ),


                    Color(
                        red:0.05,
                        green:0.03,
                        blue:0.15
                    )

                ],

                startPoint:.topLeading,

                endPoint:.bottomTrailing

            )






            Circle()

                .fill(
                    Color.green.opacity(0.18)
                )

                .frame(
                    width:300,
                    height:300
                )

                .blur(
                    radius:90
                )

                .offset(
                    x:-150,
                    y:-250
                )






            Circle()

                .fill(
                    Color.cyan.opacity(0.15)
                )

                .frame(
                    width:250,
                    height:250
                )

                .blur(
                    radius:90
                )

                .offset(
                    x:150,
                    y:300
                )



        }

        .ignoresSafeArea()



    }


}
