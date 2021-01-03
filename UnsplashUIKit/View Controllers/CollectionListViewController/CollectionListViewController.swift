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
    private let itemSpacing: CGFloat = 8
    
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
        
        collectionView.register(CollectionCell.nib(),
                                forCellWithReuseIdentifier: CollectionCell.identifier)
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
            withReuseIdentifier: CollectionCell.identifier,
            for: indexPath
        ) as! CollectionCell
        
        cell.configure(collections[indexPath.item])
        
        return cell
    }
}

// MARK: - Collection Delegate
extension CollectionListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection = collections[indexPath.item]
        
        let photosVC = PhotosViewController(id: collection.id ?? "")
        
        present(photosVC, animated: true)
    }
}

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
        let size = (collectionWidth - (itemSpacing * (numberOfColumns + 1))) / numberOfColumns
        
        return CGSize(width: size, height: size * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: 0, right: itemSpacing)
    }
}
