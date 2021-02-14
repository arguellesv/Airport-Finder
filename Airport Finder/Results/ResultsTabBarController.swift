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
        
        
        
        let listNavController = UINavigationController(rootViewController: listViewController)
        
        setViewControllers([mapViewController, listNavController], animated: true)
        
        // Workaround to render the tab buttons correctly
        mapViewController.tabBarItem = UITabBarItem(title: "Map",
                                                    image: UIImage(systemName: "mappin"),
                                                    tag: 0)
        listNavController.tabBarItem = UITabBarItem(title: "List",
                                                     image: UIImage(systemName: "list.bullet"),
                                                     tag: 1)
        
        // Workaround to force the selected tab to be highlighted.
        self.selectedIndex = 1
        self.selectedIndex = 0
        
        if isViewLoaded {
            presenter.configureViewControllerAfterLoad()
        }
    }
}

// Re-route messages to this controller's children
extension ResultsTabBarController: ResultsViewController {
    
    // Always returns the intended `ResultsViewController`, instead of a
    // parent NavigationViewController.
    private func selectedController() -> ResultsViewController? {
        switch self.selectedIndex {
            case 0:
                return self.mapViewController
            case 1:
                return self.listViewController
            default:
                return nil
        }
    }
    
    func updateResults(with airports: [Airport]) {
        guard let controller = selectedController() else { return }
        
            controller.updateResults(with: airports)
    }
    
    func setUserLocation(to location: Location) {
        guard let controller = selectedController() else { return }
            controller.setUserLocation(to: location)
    }
    
    func configure(withRadius radius: Int, location: Location, airports: [Airport]) {
        guard let controller = selectedController() else { return }
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
