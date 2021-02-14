//  RadiusSelectionPresenter.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 12/02/21.
//  
//

import Foundation
import Combine

class RadiusSelectionPresenter {
    private weak var interactor: Interactor!
//    private weak var radiusSelectionWireframe: RadiusSelectionWireframe?
    weak var viewController: RadiusSelectionController!
    
    private var resultsPresenter: ResultsPresenter!
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    init() {
        
    }
    
    deinit {
        print("Deinitializing RadiusSelectionPresenter")
    }
 
    func configure(withInteractor interactor: Interactor) {
        self.interactor = interactor
        
        let radiusSelectionWireframe = RadiusSelectionWireframe()
        radiusSelectionWireframe.radiusSelectionPresenter = self
        
        self.viewController = radiusSelectionWireframe.createViewController()
        self.viewController.eventHandler = self
    }
}

// MARK: - Interface to ViewController
extension RadiusSelectionPresenter: RadiusPresenterToViewController {
    func configureView() {
        self.viewController.configureView(with: interactor.radius)
    }
    
    func updateRadius(to newValue: Float) {
        interactor.updateRadius(to: newValue)
    }
    
    func beginSearch() {
        interactor.beginSearch()
        // TODO: Switch the search button (or at least the text) to a UIProgressView
    }
}

// MARK: - Interface to Interactor
extension RadiusSelectionPresenter: RadiusPresenterToInteractor {
    // Called when the user's location has been retrieved, which means we can present the map view.
    func didRetrieveUserLocation(_ userLocation: Location) {
        
        self.resultsPresenter = ResultsPresenter(with: interactor)
        interactor.resultsPresenter = resultsPresenter
        resultsPresenter.presentResultsView(from: viewController,
                                            userLocation: userLocation)
        
    }
    
    func radiusDidUpdate(to newValue: Int) {
        viewController.updateRadiusLabel(with: "\(newValue)")
    }
}


