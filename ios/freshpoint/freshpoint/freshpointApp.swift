//
//  freshpointApp.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import SwiftUI

@main
struct freshpointApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Button("Zapni si notifikace") {
                    let center = UNUserNotificationCenter.current()
                    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                        if let error = error {
                            // Handle the error here.
                        }
                        if granted {
                            print("Granted")
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                    }
                }
                
                FoodListView()
            }
        }
    }
    
}

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
