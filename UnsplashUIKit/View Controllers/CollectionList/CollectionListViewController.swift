//
//  CollectionListViewController.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import UIKit

final class CollectionListViewController: UICollectionViewController {
    
    // MARK: - Properties
    private var collections = [CollectionModel]()
    
    private let numberOfColumns: CGFloat = 2
    private let spacing: CGFloat = UIConstant.defaultSpacing
    
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
        
        collectionView.register(CollectionCell.nib(), forCellWithReuseIdentifier: CollectionCell.identifier)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Private methods
    private func setupUI() {
        title = "Collections"
        collectionView.backgroundColor = .white
        
        networkService.fetchCollections { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let collections):
                self.collections = collections
                self.collectionView.reloadData()
            case .failure(let error):
                if let serverError = error as? ServerError {
                    print(serverError.rawValue)
                    return
                }
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Collection View Data Source
extension CollectionListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionCell.identifier,
            for: indexPath
        ) as? CollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(collections[indexPath.item])
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension CollectionListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection = collections[indexPath.item]
        
        let photosVC = CollectionPhotosViewController(collection: collection)
        photosVC.title = collection.title
        
        // MARK: - Navigation
        navigationController?.pushViewController(photosVC, animated: true)
    }
}

// MARK: - Collection View Layout
extension CollectionListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let size = (collectionWidth - (spacing * (numberOfColumns + 1))) / numberOfColumns
        
        return CGSize(width: size, height: size * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }
}
