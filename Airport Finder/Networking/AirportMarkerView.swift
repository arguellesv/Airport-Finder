//  AirportMarkerView.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 13/02/21.
//  
//

import MapKit

class AirportMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            glyphImage = UIImage(systemName: "airplane")
        }
    }
}
