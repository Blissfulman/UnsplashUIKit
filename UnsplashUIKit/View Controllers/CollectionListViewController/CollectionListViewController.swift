//
//  CollectionListViewController.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import UIKit


final class CollectionListViewController: UICollectionViewController {
    
    // MARK: - Properties
    private var collections = [Collection]()
    
    private let numberOfColumns: CGFloat = 2
    private let itemSpacing: CGFloat = 2
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Initializers
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CollectionListCell.nib(),
                                forCellWithReuseIdentifier: CollectionListCell.identifier)
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        collectionView.backgroundColor = .white
        
        //        tabBarItem.image = UIImage(systemName: "photo.on.rectangle.angled")
        //        tabBarItem.title = "Collections"
        
        networkService.getCollections { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case let .success(collections):
                self.collections = collections
                self.collectionView.reloadData()
            case let .failure(error):
                if let serverError = error as? ServerError {
                    print(serverError.rawValue)
                    return
                }
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Collection Data Source
extension CollectionListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionListCell.identifier,
            for: indexPath
        ) as! CollectionListCell
        
        cell.configure(collections[indexPath.item])
        
        return cell
    }
}

// MARK: - Collection Delegate
extension CollectionListViewController {}

// MARK: - Collection Layout
extension CollectionListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let size = (collectionWidth - (itemSpacing * (numberOfColumns - 1))) / numberOfColumns
        
        return CGSize(width: size, height: size)
    }
}
