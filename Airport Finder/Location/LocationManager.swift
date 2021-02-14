//  LocationManager.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 11/02/21.
//  
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    var interactor: Interactor!
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func getCurrentLocation() {
        
        if CLLocationManager.locationServicesEnabled(), locationManager.authorizationStatus != .denied {
            locationManager.requestLocation()
        } else {
            print("Location services are not enabled.")
            print("Authorization status: \(locationManager.authorizationStatus)")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // TODO: Handle losing access to location data
        
        print(#function)
        switch manager.authorizationStatus {
            case .denied:
                print("Authorization is denied")
            case .notDetermined:
                print("Authorization is not determined")
            case .restricted:
                print("Authorization is restricted")
            default:
                print("Authorization is allowed")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("No locations were found.")
            return
        }
        
        if location.horizontalAccuracy > 0 {
            let userLocation = Location(latitude: location.coordinate.latitude,
                                    longitude: location.coordinate.longitude)
            
            interactor.locationDidUpdate(location: userLocation)
        } else {
            print("Received invalid location information.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        interactor.locationDidFailToUpdate(withError: error)
    }
}
