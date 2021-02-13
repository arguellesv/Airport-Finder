//  ResultsMapController.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 12/02/21.
//  
//

import UIKit
import MapKit

class ResultsMapController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var presenter: ResultsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.register(AirportMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        presenter.configureViewControllerAfterLoad()
        
        title = "Map"
        let tabBarItem = UITabBarItem(title: "",
                                      image: UIImage(systemName: "mappin"),
                                      tag: 1)
        self.tabBarItem = tabBarItem
    }
    
    deinit {
        print("Deinitializing Map Controller")
    }
}

extension ResultsMapController: ResultsViewController {
    func updateResults(with airports: [Airport]) {
        self.mapView.addAnnotations(airports)
    }
    
    func setUserLocation(to newLocation: Location) {
        guard mapView != nil else { return }
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: newLocation.latitude,
                                                 longitude: newLocation.longitude),
                          animated: true)
    }
    
    func configure(withRadius radius: Int = 10, location: Location, airports: [Airport]) {
        mapView.showsUserLocation = true
        let userLocation = CLLocationCoordinate2D(latitude: location.latitude,
                                                  longitude: location.longitude)
        
        let region = mapView.regionThatFits(MKCoordinateRegion(center: userLocation,
                                                               latitudinalMeters: Double(radius * 1000) * 1.5,
                                                               longitudinalMeters: Double(radius * 1000) * 1.5))
        
        
        self.mapView.setRegion(region, animated: true)
        updateResults(with: airports)
    }
}
