//
//  SettingsView.swift
//  freshpoint
//
//  Created by Michal Marhan on 11.05.2023.
//

import SwiftUI

struct SettingsView: View {
#if os(iOS)
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
#elseif os(macOS)
    @NSApplicationDelegateAdaptor var delegate: NSAppDelegate
#endif
    
    var body: some View {
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
        }
    }
}
