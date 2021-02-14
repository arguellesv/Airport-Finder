//  RadiusPresenterToInteractor.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 13/02/21.
//  
//

import Foundation

protocol RadiusPresenterToInteractor: class {
    func radiusDidUpdate(to: Int)
    func didRetrieveUserLocation(_:Location)
}
