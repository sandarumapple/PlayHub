//
// MainTabView.swift
// PlayHub
//

import SwiftUI


struct MainTabView: View {


    @State private var selectedTab = 0



    init() {


        let appearance =
        UITabBarAppearance()



        appearance.configureWithTransparentBackground()



        appearance.backgroundEffect =
            UIBlurEffect(
                style: .systemUltraThinMaterialDark
            )



        appearance.backgroundColor =
            UIColor.black.withAlphaComponent(0.30)



        appearance.shadowColor =
            .clear






        appearance.stackedLayoutAppearance.normal.iconColor =
            UIColor.white.withAlphaComponent(0.55)



        appearance.stackedLayoutAppearance.normal.titleTextAttributes =
        [

            .foregroundColor:
                UIColor.white.withAlphaComponent(0.55),


            .font:
                UIFont.systemFont(
                    ofSize: 11,
                    weight: .medium
                )

        ]







        appearance.stackedLayoutAppearance.selected.iconColor =
            UIColor.white



        appearance.stackedLayoutAppearance.selected.titleTextAttributes =
        [

            .foregroundColor:
                UIColor.systemMint,


            .font:
                UIFont.systemFont(
                    ofSize: 11,
                    weight: .bold
                )

        ]







        UITabBar.appearance()
            .standardAppearance =
            appearance



        UITabBar.appearance()
            .scrollEdgeAppearance =
            appearance



    }








    var body: some View {


        ZStack {


            playHubBackground






            TabView(
                selection:$selectedTab
            ) {



                HomeTab()

                    .tabItem {


                        Image(
                            systemName:
                                "house.fill"
                        )


                        Text(
                            "Home"
                        )


                    }

                    .tag(0)









                StatsTab()

                    .tabItem {


                        Image(
                            systemName:
                                "chart.bar.fill"
                        )


                        Text(
                            "Stats"
                        )


                    }

                    .tag(1)









                MapTab()

                    .tabItem {


                        Image(
                            systemName:
                                "map.fill"
                        )


                        Text(
                            "Map"
                        )


                    }

                    .tag(2)









                SettingsTab()

                    .tabItem {


                        Image(
                            systemName:
                                "gearshape.fill"
                        )


                        Text(
                            "Settings"
                        )


                    }

                    .tag(3)




            }



            .tint(
                .white
            )



        }



    }









    // MARK: PLAYHUB BACKGROUND


    private var playHubBackground: some View {


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
                    Color.mint.opacity(0.30)
                )

                .frame(
                    width:340,
                    height:340
                )

                .blur(
                    radius:120
                )

                .offset(
                    x:-160,
                    y:-320
                )









            Circle()

                .fill(
                    Color.blue.opacity(0.25)
                )

                .frame(
                    width:300,
                    height:300
                )

                .blur(
                    radius:130
                )

                .offset(
                    x:170,
                    y:320
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




}







#Preview {


    MainTabView()


}
