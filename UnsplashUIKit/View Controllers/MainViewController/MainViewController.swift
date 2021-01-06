//
//  MainViewController.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

import UIKit

final class MainViewController: UITableViewController {
    
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HeaderTableCell.nib(),
                           forCellReuseIdentifier: HeaderTableCell.identifier)
        tableView.register(CarouselTableCell.nib(),
                           forCellReuseIdentifier: CarouselTableCell.identifier)
        setupUI()
    }
    
    // MARK: - Navigation
    func showCollectionsButtonTapped(_ sender: UIButton) {
        let collectionListVC = CollectionListViewController()
        let navigationController = UINavigationController(rootViewController: collectionListVC)
        AppDelegate.shared.window?.rootViewController = navigationController
    }
    
    func searchPhotosButtonTapped(_ sender: UIButton) {
        let searchPhotosVC = SearchPhotosViewController()
        let navigationController = UINavigationController(rootViewController: searchPhotosVC)
        AppDelegate.shared.window?.rootViewController = navigationController
    }
    
    // MARK: - Private methods
    private func setupUI() {
        tableView.separatorStyle = .none
        
        tableView.setupViewGradient(
            withColors: [UIColor.systemTeal.cgColor, UIColor.systemPurple.cgColor],
            opacity: 0.1
        )
    }
}

// MARK: - Collection View Data Source
extension MainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let headerImageCell = tableView.dequeueReusableCell(
                    withIdentifier: HeaderTableCell.identifier,
                    for: indexPath
            ) as? HeaderTableCell else {
                return UITableViewCell()
            }
            return headerImageCell
        case 1, 2:
            guard let carouselTableCell = tableView.dequeueReusableCell(
                    withIdentifier: CarouselTableCell.identifier,
                    for: indexPath
            ) as? CarouselTableCell else {
                return UITableViewCell()
            }
            carouselTableCell.configure(type: indexPath.row == 1 ? .collections : .photos)
            
            return carouselTableCell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Collection View Delegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 350
        default:
            return 220
        }
    }
}
