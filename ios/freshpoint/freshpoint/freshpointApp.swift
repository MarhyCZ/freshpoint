//
//  freshpointApp.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import SwiftUI
import UserNotifications

@main
struct freshpointApp: App {
    
    var body: some Scene {
        WindowGroup {
                FoodListView()

        }
    }
}

#if os(iOS)
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Sending token...")
        print(deviceToken.hexString)
        DeviceManager().sendDeviceTokenToServer(data: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("\(error)")
    }
}

#elseif os(macOS)
class NSAppDelegate: NSObject, NSApplicationDelegate {
    
    func application(
        _ application: NSApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("Sending token...")
        print(deviceToken.hexString)
        DeviceManager().sendDeviceTokenToServer(data: deviceToken)
    }
    
}
#endif
