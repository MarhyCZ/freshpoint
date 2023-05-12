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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.04874970601164, longitude: 14.414124182262928), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
    @State private var selected = 1
#if os(iOS)
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
#elseif os(macOS)
    @NSApplicationDelegateAdaptor var delegate: NSAppDelegate
#endif
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
            VStack(spacing: 10) {
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
                List {
                    ForEach(viewModel.fridges) { fridge in
                        VStack(alignment:.leading) {
                            Text(fridge.location.name)
                            Text(fridge.userDistance.converted(to: UnitLength.kilometers).value.description).font(.caption)
                        }.listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
            }.frame(height: 200).padding(.vertical).background(.thinMaterial).cornerRadius(30)
        }
        .ignoresSafeArea()
        .task {
            await viewModel.fetch()
            viewModel.locationManager.requestLocation()
            viewModel.updateFridgesDistance()
            region.center = viewModel.locationManager.location.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
