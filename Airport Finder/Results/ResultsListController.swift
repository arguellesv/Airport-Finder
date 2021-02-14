//  ResultsListController.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 12/02/21.
//  
//

import UIKit

class ResultsListController: UIViewController {
    var presenter: ResultsPresenter?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Airport>
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Airport>
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configure()
    }
}

// MARK: - ResultsViewController methods
extension ResultsListController: ResultsViewController {
    func updateResults(with airports: [Airport]) {
        updateSnapshot(with: airports, animated: true)
    }
    
    func setUserLocation(to: Location) { }
    
    func configure(withRadius: Int, location: Location, airports: [Airport]) {
        updateSnapshot(with: airports, animated: true)
    }
}
// MARK: - View Setup
extension ResultsListController {
    private func configure() {
        view.backgroundColor = .systemFill
        self.title = "Nearby Airports"
        
        let tabItem = UITabBarItem(title: "List",
                                  image: UIImage(systemName: "list.bullet"),
                                  tag: 1)
        self.tabBarItem = tabItem
        self.navigationController?.tabBarItem = tabItem
        
        setupCollectionView()
        presenter?.configureViewControllerAfterLoad()
    }
    
    private func setupCollectionView() {
        let collectionView = UICollectionView(frame: self.view.frame,
                                              collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        dataSource = setupDataSource(collectionView: collectionView)
        
        view.addSubview(collectionView)
        view.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor).isActive = true
        
        self.collectionView = collectionView
        updateSnapshot(with: [], animated: false)
    }
    
    
    // Called when new data is available
    private func updateSnapshot(with results: [Airport], animated: Bool = true) {
        guard let dataSource = dataSource else { return }
        dataSource.apply(snapshot(from: results), animatingDifferences: animated)
    }
    
    private func snapshot(from data: [Airport]) -> NSDiffableDataSourceSnapshot<Section, Airport> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Airport>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data.sorted(by: {$0.distance < $1.distance}), toSection: .main)
        
        return snapshot
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func setupDataSource(collectionView: UICollectionView) -> DataSource {
        let cellRegistration = createCellRegistration()
        
        let dataSource: DataSource = .init(collectionView: collectionView) { (collectionView, indexPath, airport) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: airport)
            return cell
        }
        
        return dataSource
    }
    
    private func createCellRegistration() -> CellRegistration {
        let registration = CellRegistration { (cell, indexPath, airport) in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = airport.title
            configuration.secondaryText = "\(airport.cityCode) (\(airport.distance) km away)"
            
            cell.contentConfiguration = configuration
        }
        
        return registration
    }
    
    enum Section {
        case main
    }
}
