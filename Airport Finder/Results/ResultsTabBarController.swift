//  ResultsTabBarController.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 12/02/21.
//  
//

import UIKit

class ResultsTabBarController: UITabBarController {
    var presenter: ResultsPresenter!
    var mapViewController: ResultsMapController!
    var listViewController: ResultsListController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        delegate = self
    }
    
    func setControllers(mapViewController: ResultsMapController, listViewController: ResultsListController) {
        print(#function)
        self.mapViewController = mapViewController
        self.listViewController = listViewController
        
        mapViewController.tabBarItem = UITabBarItem(title: "",
                                                    image: UIImage(systemName: "mappin"),
                                                    tag: 0)
        listViewController.tabBarItem = UITabBarItem(title: "",
                                                     image: UIImage(systemName: "list.bullet"),
                                                     tag: 1)
        
//        setViewControllers([mapViewController, listViewController], animated: true)
        viewControllers = [mapViewController, listViewController]
        
        // Hack to force the selected tab to be highlighted.
        self.selectedIndex = 1
        self.selectedIndex = 0
        
        print("selectedIndex: \(selectedIndex), isViewLoaded: \(isViewLoaded)")
        
        if isViewLoaded {
            presenter.configureViewControllerAfterLoad()
        }
    }
}

// Re-route messages to this controller's children
extension ResultsTabBarController: ResultsViewController {
    func updateResults(with airports: [Airport]) {
            guard let controller = self.selectedViewController as? ResultsViewController else { return }
            controller.updateResults(with: airports)
    }
    
    func setUserLocation(to location: Location) {
            guard let controller = self.selectedViewController as? ResultsViewController else { return }
            controller.setUserLocation(to: location)
    }
    
    func configure(withRadius radius: Int, location: Location, airports: [Airport]) {
        guard let controller = self.selectedViewController as? ResultsViewController else { return }
        controller.configure(withRadius: radius, location: location, airports: airports)
    }
}

extension ResultsTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.isViewLoaded {
            presenter.configureViewControllerAfterLoad()
        }
    }
}
