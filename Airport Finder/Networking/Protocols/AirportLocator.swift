//  AirportLocator.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 11/02/21.
//  
//

import Foundation

protocol AirportLocator {
    var interactor: InteractorToAirportLocator! { get set }
    func searchAirport(from location: Location, inRadius radius: Int)
}
