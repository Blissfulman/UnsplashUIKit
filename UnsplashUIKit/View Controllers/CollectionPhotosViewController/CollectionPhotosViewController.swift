//
//  CollectionPhotosViewController.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

import UIKit

final class CollectionPhotosViewController: UICollectionViewController {
    
    // MARK: - Properties
    var collection: CollectionModel?
    var photos = [PhotoModel]()
    
    private var numberOfColumns: CGFloat = 2
    private let itemSpacing: CGFloat = 8
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Initializers
    init(collection: CollectionModel) {
        self.collection = collection
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        getPhotos(collection: collection)
    }
    
    init(photos: [PhotoModel]) {
        self.photos = photos
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(
            CollectionPhotosHeader.nib(),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionPhotosHeader.identifier
        )
        collectionView.register(PhotoCell.nib(),
                                forCellWithReuseIdentifier: PhotoCell.identifier)
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        collectionView.backgroundColor = .white
        
        guard let collection = collection else { return }
        getPhotos(collection: collection)
    }
    
    private func getPhotos(collection: CollectionModel) {
        guard let photosURL = collection.links?.photos else { return }
        
        networkService.fetchCollectionPhotos(url: photosURL) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let photos):
                self.photos = photos
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

// MARK: - Collection Data Source
extension CollectionPhotosViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionPhotosHeader.identifier,
            for: indexPath
        ) as! CollectionPhotosHeader
        
        header.delegate = self
        header.configure(collection)
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCell.identifier,
            for: indexPath
        ) as! PhotoCell
        
        cell.configure(photos[indexPath.item])
        
        return cell
    }
}

// MARK: - Collection Delegate
extension CollectionPhotosViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = photos[indexPath.item]
        let photoVC = PhotoViewController(photo: photo)
        
        // MARK: - Navigation
        navigationController?.pushViewController(photoVC, animated: true)
    }
}

// MARK: - Collection Layout
extension CollectionPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        collection != nil ? CGSize(width: collectionView.bounds.width, height: 150) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let size = (collectionWidth - (itemSpacing * (numberOfColumns + 1))) / numberOfColumns
        
        return CGSize(width: size, height: size * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: 0, right: itemSpacing)
    }
}

extension CollectionPhotosViewController: CollectionPhotosHeaderDelegate {
    
    func switchColumnNumber(columns: Int) {
        numberOfColumns = CGFloat(columns)
        collectionView.reloadData()
    }
}
