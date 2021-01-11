//
//  UITableViewControllerPaginable.swift
//  UnsplashUIKit
//
//  Created by User on 11.01.2021.
//

import UIKit

protocol CollectionsTableViewControllerPaginable: UITableViewController {
    var collections: [CollectionModel] { get set }
    var loadedPages: Int { get set }
    var links: PaginationLinks? { get set }
    var networkService: NetworkServiceProtocol { get }
}

extension CollectionsTableViewControllerPaginable {
    
    func loadNextPageFoundCollections(forSection section: Int) {//completion: @escaping SearchCollectionsResult) {
        guard let urlLink = links?[RelationLinkType.next],
              let url = urlLink else { return }
        
        networkService.searchCollections(url: url) {
            [weak self] result, links in
            
            guard let self = self else { return }
            
            self.links = links
            
            switch result {
            case .success(let searchCollectionsResult):
                
                guard let collections = searchCollectionsResult.collections else { return }
                
                self.collections.append(contentsOf: collections)
                
                let indexPaths = self.getNextPageIndexPaths(
                    loadedPages: self.loadedPages,
                    newItemsCount: searchCollectionsResult.collections?.count ?? 0,
                    section: section
                )
                self.tableView.insertRows(at: indexPaths, with: .automatic)
                
                self.loadedPages += 1
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
}
