//
//  LocationService.swift
//  PlayHub
//

import Foundation
import CoreLocation
import Combine


final class LocationService: NSObject, ObservableObject {


    @Published var location: CLLocation?

    @Published var authorizationStatus:
    CLAuthorizationStatus = .notDetermined



    private let manager =
    CLLocationManager()





    override init() {

        super.init()


        manager.delegate = self


        manager.desiredAccuracy =
        kCLLocationAccuracyBest


        manager.distanceFilter =
        kCLDistanceFilterNone



        if #available(iOS 14.0, *) {


            authorizationStatus =
            manager.authorizationStatus


        } else {


            authorizationStatus =
            CLLocationManager.authorizationStatus()


        }


    }







    func requestPermission(){


        print(
            "REQUEST LOCATION PERMISSION"
        )



        switch manager.authorizationStatus {



        case .notDetermined:


            manager.requestWhenInUseAuthorization()



        case .authorizedAlways,
             .authorizedWhenInUse:


            startUpdating()



        case .denied,
             .restricted:


            print(
                "LOCATION PERMISSION DENIED"
            )



        default:

            break

        }


    }







    func startUpdating(){


        print(
            "START LOCATION UPDATE"
        )


        manager.startUpdatingLocation()


    }






    func stopUpdating(){


        manager.stopUpdatingLocation()


    }




}









extension LocationService:
CLLocationManagerDelegate {






    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ){


        if #available(iOS 14.0, *) {


            authorizationStatus =
            manager.authorizationStatus


        }



        switch manager.authorizationStatus {



        case .authorizedAlways,
             .authorizedWhenInUse:


            startUpdating()



        case .denied,
             .restricted:


            print(
                "LOCATION BLOCKED"
            )



        default:

            break

        }


    }









    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations:[CLLocation]
    ){



        guard let newLocation =
                locations.last
        else {

            return

        }






        DispatchQueue.main.async {



            self.location =
            newLocation



            print(
                "REAL LOCATION:",
                newLocation.coordinate.latitude,
                newLocation.coordinate.longitude
            )



            NotificationCenter.default.post(
                name: .locationUpdated,
                object: newLocation
            )



        }



    }










    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ){


        print(
            "LOCATION ERROR:",
            error.localizedDescription
        )


    }



}









extension Notification.Name {


    static let locationUpdated =
    Notification.Name(
        "locationUpdated"
    )

}
