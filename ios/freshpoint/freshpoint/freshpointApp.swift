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
#if os(iOS)
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
#elseif os(macOS)
    @NSApplicationDelegateAdaptor var delegate: NSAppDelegate
#endif
    
    var body: some Scene {
        WindowGroup {
            TabView {
                FoodListView()
                    .tabItem {
                        Label("Menu", systemImage: "takeoutbag.and.cup.and.straw").labelStyle(.iconOnly)
                    }
                List {
                    Button("Zapni si notifikace") {
                        let center = UNUserNotificationCenter.current()
                        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                            if let error = error {
                                // Handle the error here.
                            }
                            if granted {
                                print("Granted")
                                DispatchQueue.main.async {
#if os(iOS)
                                    UIApplication.shared.registerForRemoteNotifications()
#elseif os(macOS)
                                    NSApplication.shared.registerForRemoteNotifications()
#endif
                                }
                            }
                        }
                    }
                }.tabItem{
                    Label("Nastavení", systemImage: "location").labelStyle(.iconOnly)}
            }.tableStyle(.inset)
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


extension UIApplication {
    static var firstKeyWindowForConnectedScenes: UIWindow? {
        UIApplication.shared
            // Of all connected scenes...
            .connectedScenes.lazy

            // ... grab all foreground active window scenes ...
            .compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil }

            // ... finding the first one which has a key window ...
            .first(where: { $0.keyWindow != nil })?

            // ... and return that window.
            .keyWindow
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
