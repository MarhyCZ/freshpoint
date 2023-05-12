//
//  SettingsViewModel.swift
//  freshpoint
//
//  Created by Michal Marhan on 11.05.2023.
//

import Foundation
import CoreLocation

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
        
    }
    
    func updateFridgesDistance() {
        fridges = locationManager.calculateDistance(from: fridges)
        fridges = fridges.sorted (by: { $0.userDistance < $1.userDistance })
    }
    func closestLocation(locations: [CLLocation], closestToLocation location: CLLocation) -> CLLocation? {
        if let closestLocation = locations.min(by: { location.distance(from: $0) < location.distance(from: $1) }) {
            print("closest location: \(closestLocation), distance: \(location.distance(from: closestLocation))")
            return closestLocation
        } else {
            print("coordinates is empty")
            return nil
        }
    }
    
}
