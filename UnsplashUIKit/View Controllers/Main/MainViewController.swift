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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Private methods
    private func setupUI() {
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
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
            carouselTableCell.configure(contentType: indexPath.row == 1 ? .collection : .photo)
            carouselTableCell.delegate = self
            
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
            return UIConstant.mainViewHeaderHeight
        default:
            return UIConstant.mainViewCarouselHeight
        }
    }
}

// MARK: - Navigation
extension MainViewController: CarouselTableCellDelegate {
    
    func searchCollections() {
        let searchVC = SearchViewController(contentType: .collection)
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func searchPhotos() {
        let searchVC = SearchViewController(contentType: .photo)
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func onPhotoTapped(photo: PhotoModel) {
        let onePhotoVC = OnePhotoViewController(photo: photo)
        navigationController?.pushViewController(onePhotoVC, animated: true)
    }
    
    func onCollectionTapped(collection: CollectionModel) {
        let photoListVC = PhotoListViewController(collection: collection)
        photoListVC.title = collection.title
        
        navigationController?.pushViewController(photoListVC, animated: true)
    }
}
