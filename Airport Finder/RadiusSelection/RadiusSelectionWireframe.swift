//  RadiusSelectionWireframe.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 12/02/21.
//  
//

import UIKit

class RadiusSelectionWireframe {
    var radiusSelectionPresenter: RadiusSelectionPresenter?
    
    let radiusSelectionControllerIdentifier = "RadiusSelectionController"
    
    private var mainStoryboard: UIStoryboard {
        get { UIStoryboard(name: "Main", bundle: Bundle.main) }
    }
    
    func createViewController() -> RadiusSelectionController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: radiusSelectionControllerIdentifier) as! RadiusSelectionController
        
        return viewController
    }
}
