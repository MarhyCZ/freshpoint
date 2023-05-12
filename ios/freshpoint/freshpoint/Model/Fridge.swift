//
//  Fridge.swift
//  freshpoint
//
//  Created by Michal Marhan on 11.05.2023.
//

import Foundation
import CoreLocation

struct Fridge {
    let prop: FridgeProp
    let location: FridgeLocation
    
    var corelocation: CLLocation {
        return CLLocation(latitude: location.lat, longitude: location.lon)
    }
    var userDistance: CLLocationDistance = 1000
}

extension Fridge: HasLocations {}
extension Fridge: Codable {
    private enum CodingKeys: String, CodingKey {
            case prop, location
        }
}
extension Fridge: Identifiable {
    var id: Int {
        return self.prop.id
    }
}

struct FridgeProp {
    let id: Int
    let username: String
    let address: String
    let lat: Double
    let lon: Double
    let active: Int
    let discount: Int
    let suspended: Int
}

extension FridgeProp: Codable {}

struct FridgeLocation {
    let name: String
    let address: String
    let lat: Double
    let lon: Double
}

extension FridgeLocation: Codable {}
