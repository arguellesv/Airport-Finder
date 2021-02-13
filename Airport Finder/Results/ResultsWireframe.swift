//  ResultsWireframe.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 12/02/21.
//  
//

import UIKit

class ResultsWireframe {
    var resultsPresenter: ResultsPresenter?
    
    let resultsMapIdentifier = "ResultsMapController"
    
    private var mainStoryboard: UIStoryboard {
        get { UIStoryboard(name: "Main", bundle: Bundle.main) }
    }
    
    
    func presentResultsViewController(from presentingController: UIViewController) {
        let viewController = makeResultsViewController()
        viewController.modalPresentationStyle = .fullScreen
        
        presentingController.present(viewController,
                                     animated: true,
                                     completion: nil)
    }
    
    
    private func makeResultsViewController() -> ResultsTabBarController {
        let mapViewController = makeResultsMapController()
        let listViewController = makeResultsListController()
        
        let viewController = ResultsTabBarController()
        resultsPresenter?.viewController = viewController
        viewController.presenter = resultsPresenter
        
        viewController.setControllers(mapViewController: mapViewController,
                                      listViewController: listViewController)
        
        return viewController
    }
    
    private func makeResultsMapController() -> ResultsMapController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: resultsMapIdentifier) as! ResultsMapController
        viewController.presenter = resultsPresenter
        return viewController
    }
    
    private func makeResultsListController() -> ResultsListController {
        let viewController = ResultsListController()
        viewController.presenter = resultsPresenter
        return viewController
    }
    
}
