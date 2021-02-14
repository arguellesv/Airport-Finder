//  RadiusPresenterToViewController.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 13/02/21.
//  
//

import Foundation

protocol RadiusPresenterToViewController: class {
    func configureView()
    func updateRadius(to: Float)
    func beginSearch()
}
