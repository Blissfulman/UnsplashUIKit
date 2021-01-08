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
    private let edgeWidth = UIConstant.defaultEdgeWidth
    private let spacing = UIConstant.defaultSpacing
    
    // MARK: - Initializers
    init(collections: [CollectionModel]) {
        self.collections = collections
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
        collectionView.backgroundColor = .white
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
        
        let photoListVC = PhotoListViewController(collection: collection)
        photoListVC.title = collection.title
        
        // MARK: - Navigation
        navigationController?.pushViewController(photoListVC, animated: true)
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
        
        let sizeWidth = calculateSizeWidth(
            spacing: spacing, edgeWidth: edgeWidth, numberOfColumns: numberOfColumns
        )
        return CGSize(width: sizeWidth, height: sizeWidth * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: edgeWidth, left: edgeWidth, bottom: edgeWidth, right: edgeWidth)
    }
}
