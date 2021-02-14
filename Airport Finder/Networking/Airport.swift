//  Airport.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 12/02/21.
//  
//

import Foundation
import MapKit

class Airport: NSObject, MKAnnotation {
    let name: String
    var coordinate: CLLocationCoordinate2D
    
    let airportCode: String
    let cityCode: String
    let countryCode: String
    let distance: Int
    
    init(name: String,
         location: Location,
         airportCode: String,
         cityCode: String,
         countryCode: String,
         distance: Int) {
        self.name = name
        self.airportCode = airportCode
        self.cityCode = cityCode
        self.countryCode = countryCode
        self.distance = distance
        
        self.coordinate = .init(latitude: location.latitude,
                                longitude: location.longitude)
        
        super.init()
    }
    
    var title: String? {
        get { "\(name) (\(airportCode))" }
    }
    
    var subtitle: String? {
        get { "\(distance) km away" }
    }
    
}
