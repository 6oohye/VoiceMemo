//
//  voiceMemoApp.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/29/24.
//

import SwiftUI

@main
struct voiceMemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    //UIKit의 UI App Delegete와 상호작용 가넝
    var body: some Scene {
        WindowGroup {
           OnboardingView()
        }
    }
}
