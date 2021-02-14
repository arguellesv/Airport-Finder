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
        
        mapView.delegate = self
        
        presenter.configureViewControllerAfterLoad()
        
        title = "Map"
        tabBarItem = UITabBarItem(title: "Map",
                                  image: UIImage(systemName: "mappin"),
                                  tag: 0)
        
    }
    
    deinit {
        print("Deinitializing Map Controller")
    }
}

// MARK: - ResultsViewController methods
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
        
        let region = MKCoordinateRegion(center: userLocation,
                                        latitudinalMeters: Double(radius * 1000) * 2,
                                        longitudinalMeters: Double(radius * 1000) * 2)
        
        
        self.mapView.setRegion(region, animated: true)
        showRadius(ofSize: radius, location: userLocation)
        updateResults(with: airports)
    }
    
    func showRadius(ofSize radius: Int, location: CLLocationCoordinate2D) {
        let circle = MKCircle(center: location, radius: CLLocationDistance(radius*1000))
        circle.title = "Radius"
        
        mapView.addOverlay(circle, level: MKOverlayLevel.aboveRoads)
    }
}

extension ResultsMapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.title == "Radius", overlay.isKind(of: MKCircle.self) {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.systemTeal.withAlphaComponent(0.1)
            renderer.strokeColor = UIColor.systemTeal.withAlphaComponent(0.7)
            renderer.lineWidth = 3
            
            return renderer
        }
        
        return MKOverlayRenderer()
    }
}
