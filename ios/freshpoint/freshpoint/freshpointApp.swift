//
//  freshpointApp.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import SwiftUI

@main
struct freshpointApp: App {
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Sending token...")
        print(deviceToken.hexString)
        DeviceManager().sendDeviceTokenToServer(data: deviceToken)
       }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

        print("I am not available in simulator :( \(error)")
    }
}
