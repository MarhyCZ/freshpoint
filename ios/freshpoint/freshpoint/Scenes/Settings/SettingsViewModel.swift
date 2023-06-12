//
//  SettingsViewModel.swift
//  freshpoint
//
//  Created by Michal Marhan on 11.05.2023.
//

import Foundation
import CoreLocation
import UserNotifications
import MapKit

@MainActor final class SettingsViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case fetched
        case failed
    }
    
    @Published var state: State = .initial
    @Published var fridges: [Fridge] = [Fridge]()
    @Published var locationManager = LocationManager()
    @Published var closestFridge: Fridge?
    @Published var selectedFridge: Fridge?
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.04874970601164, longitude: 14.414124182262928), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
    
    func fetch() async {
        state = .loading
        
        do {
            let data = try await FoodItemFetcher().fetchFridges()
            fridges = data
            state = .fetched
        } catch {
            print("Error while fetching data for SettingsViewModel")
            state = .failed
        }
        
        updateFridgesDistance()
        mapRegion.center = locationManager.location.coordinate
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        
    }
    
    func updateFridgesDistance() {
        locationManager.requestLocation()
        fridges = locationManager.calculateDistance(from: fridges)
        fridges = fridges.sorted (by: { $0.userDistance < $1.userDistance })
        closestFridge = fridges[0]
        selectedFridge = closestFridge
    }
    
    func selectFridge(_ fridge: Fridge) {
        selectedFridge = fridge
        mapRegion.center = fridge.corelocation.coordinate
    }
    
    func enableNotifications() {
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
