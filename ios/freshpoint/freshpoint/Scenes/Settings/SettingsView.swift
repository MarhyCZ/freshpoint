//
//  SettingsView.swift
//  freshpoint
//
//  Created by Michal Marhan on 11.05.2023.
//

import SwiftUI
import MapKit
import UserNotifications

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.04874970601164, longitude: 14.414124182262928), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
#if os(iOS)
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
#elseif os(macOS)
    @NSApplicationDelegateAdaptor var delegate: NSAppDelegate
#endif
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: viewModel.fridges) {
                MapAnnotation(coordinate: $0.corelocation.coordinate) {
                    Image(systemName: "refrigerator.fill")
                        .foregroundColor(.white)
                        .frame(width: 15,height: 15)
                        .padding(10)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        
                }
                    }
                    .frame(width: 400, height: 600)
            Button("Aktualizovat vzdálenost") {
                viewModel.locationManager.requestLocation()
                viewModel.updateFridgesDistance()
            }
            List {
                ForEach(viewModel.fridges) { fridge in
                    VStack(alignment:.leading) {
                        Text(fridge.location.name)
                        Text(fridge.userDistance.description).font(.caption)
                    }
                }
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
        .ignoresSafeArea()
        .task {
            await viewModel.fetch()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
