//
//  MapTab.swift
//  PlayHub
//

import SwiftUI
import MapKit
import CoreLocation


struct MapTab: View {


    @StateObject private var locationService =
    LocationService()


    @EnvironmentObject var playerVM: PlayerVM



    // Do not default to Colombo; MapKit follows the device's location instead.
    @State private var camera: MapCameraPosition = .userLocation(fallback: .automatic)




    var body: some View {


        ZStack {


            Map(position: $camera) {


                UserAnnotation()


            }

            .mapStyle(.standard)


            .mapControls {


                MapUserLocationButton()

                MapCompass()

                MapScaleView()


            }

            .ignoresSafeArea()






            VStack {


                locationCard



                Spacer()



                findButton



            }



        }



        .navigationTitle("Map")


        .navigationBarTitleDisplayMode(.inline)



        .onAppear {


            locationService.requestPermission()


        }




        .onReceive(
            locationService.$location
        ) { location in


            guard let location else {

                return

            }



            print(
                "MAP LOCATION:",
                location.coordinate.latitude,
                location.coordinate.longitude
            )



            // SAVE LOCATION TO CURRENT PLAYER

            playerVM.updateLocation(
                location
            )



            moveCamera(
                to: location
            )



        }



    }







    // MARK: LOCATION CARD


    private var locationCard: some View {


        VStack(
            alignment:.leading,
            spacing:8
        ) {



            Text(
                "🎮 PlayHub Location"
            )
            .font(.title2)
            .bold()
            .foregroundStyle(.white)





            if let location =
                locationService.location {



                Text(
                    """
                    Latitude:
                    \(location.coordinate.latitude,
                      specifier:"%.5f")


                    Longitude:
                    \(location.coordinate.longitude,
                      specifier:"%.5f")
                    """
                )
                .font(.caption)
                .foregroundStyle(
                    .white.opacity(0.8)
                )



            } else {



                Text(
                    "Finding location..."
                )
                .font(.caption)
                .foregroundStyle(
                    .white.opacity(0.8)
                )


            }




        }

        .padding()


        .frame(
            maxWidth:.infinity,
            alignment:.leading
        )


        .background(
            .ultraThinMaterial
        )


        .clipShape(
            RoundedRectangle(
                cornerRadius:20
            )
        )


        .padding()



    }









    // MARK: BUTTON


    private var findButton: some View {


        Button {


            locationService.requestCurrentLocation()



        } label:{



            Label(
                "Find Me",
                systemImage:"location.fill"
            )


            .font(.headline)
            .bold()


            .frame(
                width:180,
                height:50
            )


            .background(
                .green
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

        .padding(.bottom,30)



    }









    // MARK: CAMERA MOVE


    private func moveCamera(
        to location: CLLocation
    ) {


        withAnimation(
            .easeInOut(duration:1)
        ) {


            camera =
            .region(


                MKCoordinateRegion(

                    center:
                        location.coordinate,


                    span:
                        MKCoordinateSpan(

                            latitudeDelta:0.005,

                            longitudeDelta:0.005

                        )

                )


            )


        }


    }



}








#Preview {


    NavigationStack {


        MapTab()

    }


}
