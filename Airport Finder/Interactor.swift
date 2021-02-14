//  Interactor.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 12/02/21.
//  
//

import Foundation

protocol InteractorToAirportLocator {
    func didUpdateAirportResults(_: [Airport])
    func didFailToLocateAirports(with: Error)
}

class Interactor {
    var radiusPresenter: RadiusPresenterToInteractor?
    var resultsPresenter: ResultsPresenterToInteractor?
    private var locationManager: LocationManager?
    private var locator: AirportLocator = LufthansaLocator()
    
    var radius: Int = 20 {
        didSet {
            radiusPresenter?.radiusDidUpdate(to: radius)
        }
    }
    var userLocation: Location = .zero
    var airports: [Airport] = []
    
    init() {
        self.radius = 20
        self.locator = LufthansaLocator()
        locator.interactor = self
    }
    
    func setupWith(radiusSelectionPresenter: RadiusPresenterToInteractor) {
        self.radiusPresenter = radiusSelectionPresenter
        radiusPresenter?.radiusDidUpdate(to: self.radius)
    }
}

// MARK: - Interface to RadiusSelectionPresenter
extension Interactor {
    func updateRadius(to newValue: Float) {
        radius = Int(newValue.rounded())
    }
    
    func beginSearch() {
        self.locationManager = LocationManager()
        locationManager?.interactor = self
        locationManager?.getCurrentLocation()
    }
}

// MARK: - Interface to LocationManager
extension Interactor {
    func locationDidUpdate(location: Location) {
        self.userLocation = location
        
        // Notify the RadiusPresenter so it can present the next view
        radiusPresenter?.didRetrieveUserLocation(location)
        
        // Tell QueryService to search
        locator.searchAirport(from: location, inRadius: radius)
        
        // Maybe nullify the LocationManager, since it will no longer be used
        //        locationManager = nil
    }
    
    func locationDidFailToUpdate(withError error: Error) {
        // TODO: Handle errors
        // If the problem is lack of authorization, inform the user
        // and ask them to turn on location services for the app.
        // Otherwise, try again by ourselves, or tell the user to try again later.
        print("Error finding the user's location: \(error.localizedDescription)\n\n\(error)")
    }
}

// MARK: - Interface to AirportLocator
extension Interactor: InteractorToAirportLocator {
    func didUpdateAirportResults(_ results: [Airport]) {
        print("Found \(results.count) airports nearby.")
        self.airports = results
        resultsPresenter?.updateResults(with: results)
    }
    
    func didFailToLocateAirports(with error: Error) {
        // TODO: Handle errors
        // - Notify the user
        // - Offer ways to try again
        print("Error locating airports: \(error.localizedDescription)\n\(error)")
    }
}
