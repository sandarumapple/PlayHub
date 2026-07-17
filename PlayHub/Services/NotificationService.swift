//
// NotificationService.swift
//

import Foundation
import UserNotifications



final class NotificationService {


    static let shared =
    NotificationService()



    private init(){}




    func requestPermission(){


        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options:[
                    .alert,
                    .sound,
                    .badge
                ]
            ){ _,_ in

            }

    }





    func sendGameReminder(){


        let content =
        UNMutableNotificationContent()


        content.title =
        "PlayHub Challenge"


        content.body =
        "Beat your high score today!"


        content.sound =
        .default



        let trigger =
        UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats:false
        )



        let request =
        UNNotificationRequest(
            identifier:"playhub",
            content:content,
            trigger:trigger
        )



        UNUserNotificationCenter
            .current()
            .add(request)

    }

}
