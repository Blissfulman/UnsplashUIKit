//
//  MainViewController.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

import UIKit

final class MainViewController: UITableViewController {
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(HeaderTableCell.nib(),
                           forCellReuseIdentifier: HeaderTableCell.identifier)
        tableView.register(CarouselTableCell.nib(),
                           forCellReuseIdentifier: CarouselTableCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - Table View Data Source
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
        default:
            guard let carouselTableCell = tableView.dequeueReusableCell(
                    withIdentifier: CarouselTableCell.identifier,
                    for: indexPath
            ) as? CarouselTableCell else {
                return UITableViewCell()
            }
            carouselTableCell.configure(contentType: indexPath.row == 1 ? .collection : .photo)
            carouselTableCell.delegate = self
            
            return carouselTableCell
        }
    }
}

// MARK: - Table View Delegate
extension MainViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UIConstant.mainViewHeaderHeight
        default:
            return UIConstant.mainViewCarouselHeight
        }
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            guard let headerImageCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0))
                    as? HeaderTableCell else { return }
            
            guard let photo = headerImageCell.photo else { return }
            
            let onePhotoVC = OnePhotoViewController(photo: photo)
            navigationController?.pushViewController(onePhotoVC, animated: true)
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
    
    func onCollectionTapped(collection: CollectionModel) {
        let collectionPhotosVC = CollectionPhotosViewController(collection: collection)
        collectionPhotosVC.title = collection.title
        
        navigationController?.pushViewController(collectionPhotosVC, animated: true)
    }
    
    func onPhotoTapped(photo: PhotoModel) {
        let onePhotoVC = OnePhotoViewController(photo: photo)
        navigationController?.pushViewController(onePhotoVC, animated: true)
    }
}
