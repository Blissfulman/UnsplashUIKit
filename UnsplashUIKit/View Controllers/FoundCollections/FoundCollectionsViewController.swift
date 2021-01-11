//
//  FoundCollectionsViewController.swift
//  UnsplashUIKit
//
//  Created by User on 08.01.2021.
//

import UIKit

final class FoundCollectionsViewController: UITableViewController, CollectionsTableViewControllerPaginable {
    
    // MARK: - Properties
    /// Отображаемые (загруженные) коллекции
    var collections = [CollectionModel]()
    
    /// Общее количество элементов в отображаемом списке
    private let totalItems: Int
    
    /// Количество загруженных страниц
    var loadedPages = 1
    
    var links: PaginationLinks?
    let networkService: NetworkServiceProtocol = NetworkService()
    
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
        
        tableView.register(CollectionCell.nib(),
                           forCellReuseIdentifier: CollectionCell.identifier)
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
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
        section == 0 ? UIConstant.collectionListHeaderHeight : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.width / 3.5
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let displayedItems = loadedPages * APIConstant.itemsPerPage
        let isNeedLoading = displayedItems - indexPath.row == 10
        
        if isNeedLoading {
            print("Need loading...")
            loadNextPageFoundCollections(forSection: 1)
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
