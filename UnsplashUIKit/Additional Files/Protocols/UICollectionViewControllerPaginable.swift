//
//  UICollectionViewControllerPaginable.swift
//  UnsplashUIKit
//
//  Created by User on 11.01.2021.
//

import UIKit

protocol PhotosCollectionViewControllerPaginable: UICollectionViewController {
    var photos: [PhotoModel] { get set }
    var loadedPages: Int { get set }
    var links: PaginationLinks? { get set }
    var paginationService: PaginationServiceProtocol { get }
}

extension PhotosCollectionViewControllerPaginable {

    func loadNextPageFoundPhotos(forSection section: Int) {
        guard let urlLink = links?[RelationLinkType.next],
              let url = urlLink else { return }
        
        paginationService.searchPhotos(url: url) {
            [weak self] result, links in

            guard let self = self else { return }

            self.links = links

            switch result {
            case .success(let searchPhotossResult):

                guard let photos = searchPhotossResult.photos else { return }

                self.photos.append(contentsOf: photos)

                let indexPaths = self.getNextPageIndexPaths(
                    loadedPages: self.loadedPages,
                    newItemsCount: searchPhotossResult.photos?.count ?? 0,
                    section: section
                )
                self.collectionView.insertItems(at: indexPaths)

                self.loadedPages += 1
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    func loadNextPageCollectionPhotos(forSection section: Int) {
        guard let urlLink = links?[RelationLinkType.next],
              let url = urlLink else { return }
        
        paginationService.fetchCollectionPhotos(url: url) {
            [weak self] result, links in

            guard let self = self else { return }

            self.links = links

            switch result {
            case .success(let photos):

                self.photos.append(contentsOf: photos)

                let indexPaths = self.getNextPageIndexPaths(
                    loadedPages: self.loadedPages,
                    newItemsCount: photos.count,
                    section: section
                )
                self.collectionView.insertItems(at: indexPaths)

                self.loadedPages += 1
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
}
