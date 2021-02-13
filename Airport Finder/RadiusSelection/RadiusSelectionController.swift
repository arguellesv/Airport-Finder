//  ViewController.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 11/02/21.
//  
//

import UIKit

class RadiusSelectionController: UIViewController {

    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var searchButton: UIButton!

    weak var eventHandler: RadiusPresenterToViewController! {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        eventHandler.configureView()
    }

    func configureView(with radius: Int) {
        radiusSlider.maximumValue = 100.0
        radiusSlider.minimumValue = 0
        
        self.radiusSlider.setValue(Float(radius),
                                   animated: false)
        self.radiusLabel.text = "\(radius)"
    }
    
    // MARK: - IBActions
    
    @IBAction func sliderChanged(_ sender: Any) {
        eventHandler.updateRadius(to: radiusSlider.value)
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        eventHandler.beginSearch()
    }
    
    // MARK: - Presenter Interface
    func updateRadiusLabel(with newText: String) {
        radiusLabel.text = newText
    }
    
}

