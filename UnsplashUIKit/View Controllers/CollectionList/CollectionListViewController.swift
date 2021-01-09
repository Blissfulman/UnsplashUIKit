//
//  CollectionListViewController.swift
//  UnsplashUIKit
//
//  Created by User on 08.01.2021.
//

import UIKit

final class CollectionListViewController: UITableViewController {
        
    // MARK: - Properties
    private var collections = [CollectionModel]()
    private let totalCollections: Int
    
    // MARK: - Initializers
    init(collections: [CollectionModel], totalCollections: Int) {
        self.collections = collections
        self.totalCollections = totalCollections
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
extension CollectionListViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Total collections: \(totalCollections)"
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collections.count
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
extension CollectionListViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.width / 3.5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = collections[indexPath.item]
        
        let photoListVC = PhotoListViewController(collection: collection)
        photoListVC.title = collection.title
        
        // MARK: - Navigation
        navigationController?.pushViewController(photoListVC, animated: true)
    }
}
