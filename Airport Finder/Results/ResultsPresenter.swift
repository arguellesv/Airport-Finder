//  ResultsPresenter.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 12/02/21.
//  
//

import Foundation

protocol ResultsPresenterToInteractor {
    func updateResults(with airports: [Airport])
}

class ResultsPresenter {
    var resultsWireframe: ResultsWireframe!
    var interactor: Interactor
    
    weak var viewController: ResultsViewController!
    //    let listView: ListResultsView
    
    init(with interactor: Interactor) {
        self.interactor = interactor
        self.resultsWireframe = ResultsWireframe()
        
        resultsWireframe.resultsPresenter = self
    }
    
    func presentResultsView(from presentingController: RadiusSelectionController,
                            userLocation: Location) {
        resultsWireframe.presentResultsViewController(from: presentingController)
    }
    
    func configureViewControllerAfterLoad() {
        DispatchQueue.main.async {
            self.viewController.configure(withRadius: self.interactor.radius,
                                          location: self.interactor.userLocation,
                                          airports: self.interactor.airports)
        }
    }
}

// MARK: - Interface to the Interactor
extension ResultsPresenter: ResultsPresenterToInteractor {
    func updateResults(with airports: [Airport]) {
        DispatchQueue.main.async {
            self.viewController.updateResults(with: airports)
        }
    }
}
