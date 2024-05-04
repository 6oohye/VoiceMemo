//
//  AppDelegate.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/29/24.
//

import UIKit

class AppDelegate: NSObject,UIApplicationDelegate {
    var notificationDelegate = NotificationDelegate()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        return true
    }
}
