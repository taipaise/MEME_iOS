//
//  AppDelegate+Notification.swift
//  MEME
//
//  Created by 이동현 on 7/9/24.
//

import UIKit
import FirebaseCore
import FirebaseMessaging


extension AppDelegate {
    func requestNotificationAuth() {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
       
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
       
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification) async
        -> UNNotificationPresentationOptions {
            //알림 수신 처리
            let userInfo = notification.request.content.userInfo
            print(userInfo)
            return [[.banner, .list]]
      }

      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo

        // ...

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print(userInfo)
      }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
    }
}
