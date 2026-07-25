//
// NotificationService.swift
//

import Foundation
import UserNotifications

final class NotificationService: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationService()

    private let reminderIdentifier = "playhub.dailyGameReminder"

    private override init() {
        super.init()
        configure()
    }

    func configure() {
        UNUserNotificationCenter.current().delegate = self
    }

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func scheduleDailyGameReminder(at date: Date, completion: @escaping (Error?) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = "Ready to play?"
        content.body = "Take a quick PlayHub challenge and beat your high score!"
        content.sound = .default

        let time = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        let request = UNNotificationRequest(
            identifier: reminderIdentifier,
            content: content,
            trigger: trigger
        )

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
        center.add(request) { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

    func cancelGameReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
    }

    func sendTestGameReminder(completion: @escaping (Error?) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = "Ready to play?"
        content.body = "Your PlayHub test reminder is working!"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "playhub.testGameReminder",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        )

        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }
}
