//
//  FoundCollectionsViewController.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 08.01.2021.
//

import UIKit

final class FoundCollectionsViewController: UITableViewController {
    
    // MARK: - Properties
    /// Отображаемые (загруженные) коллекции.
    private var collections = [CollectionModel]()
    
    /// Общее количество элементов в отображаемом списке.
    private let totalItems: Int
    
    private var links: PaginationLinks?
    private let paginationService: PaginationServiceProtocol = PaginationService()
    
    // MARK: - Initializers
    init(collections: [CollectionModel], totalItems: Int, links: PaginationLinks?) {
        self.collections = collections
        self.totalItems = totalItems
        self.links = links
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CollectionCell.nib(), forCellReuseIdentifier: CollectionCell.identifier)
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
    }
    
    // MARK: - Pagination
    private func loadNextPage() {
        guard let nextLink = links?[RelationLinkType.next],
              let url = nextLink else { return }
        
        paginationService.searchCollections(url: url) {
            [weak self] result, links in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let searchCollectionsResult):
                
                guard let collections = searchCollectionsResult.collections else { return }
                
                let indexPaths = self.getNextPageIndexPaths(
                    loadedItems: self.collections.count,
                    newItemsCount: searchCollectionsResult.collections?.count ?? 0,
                    section: 1
                )
                self.collections.append(contentsOf: collections)
                self.links = links
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            case .failure(let error):
                self.showErrorAlert(error)
            }
        }
    }
}

// MARK: - Table View Data Source
extension FoundCollectionsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Total collections: \(totalItems)"
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 0 : collections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionCell.identifier, for: indexPath
        ) as? CollectionCell else {
            return UITableViewCell()
        }
        cell.configure(collections[indexPath.item])
        
        return cell
    }
}

// MARK: - Table View Delegate
extension FoundCollectionsViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? UIConstants.collectionListHeaderHeight : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.width / UIConstants.collectionCellSidesRatio
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (totalItems > collections.count) && (collections.count - indexPath.row == 5) {
            print("Pagination loading...")
            loadNextPage()
        }
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = collections[indexPath.item]
        
        let collectionPhotosVC = CollectionPhotosViewController(collection: collection)
        collectionPhotosVC.title = collection.title
        
        navigationController?.pushViewController(collectionPhotosVC, animated: true)
    }
}
