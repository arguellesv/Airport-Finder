//  ResultsViewController.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 12/02/21.
//  
//

import Foundation

protocol ResultsViewController: class {
    func updateResults(with: [Airport])
    func setUserLocation(to: Location)
    func configure(withRadius: Int, location: Location, airports: [Airport])
}
