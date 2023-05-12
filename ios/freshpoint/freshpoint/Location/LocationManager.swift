//
//  LocationManager.swift
//  freshpoint
//
//  Created by Michal Marhan on 11.05.2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    @Published var location: CLLocation = CLLocation(latitude: 50.04874970601164, longitude: 14.414124182262928)

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.location = location
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print(error.localizedDescription)
    }

    func calculateDistance<T>(from locationStructs: [T]) -> [T] where T: HasLocations {
        var newStructs = [T]()
        for locationStruct in locationStructs {
            let distance = location.distance(from: locationStruct.corelocation)
            var newStruct = locationStruct
            newStruct.userDistance = Measurement(value: distance, unit: UnitLength.meters)
            newStructs.append(newStruct)
        }
        return newStructs
    }
}

protocol HasLocations {
    var corelocation: CLLocation { get }
    var userDistance: Measurement<UnitLength> { get set }
}
