//
//  PhotoListViewController.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

import UIKit

final class PhotoListViewController: UICollectionViewController {
    
    // MARK: - Properties
    var photos = [PhotoModel]()
    
    /// Общее количество фотографий в отображаемом списке
    let totalPhotos: Int
    
    private var numberOfColumns = UIConstant.defaultNumberOfColumns
    private let edgeWidth = UIConstant.defaultEdgeWidth
    private let spacing = UIConstant.defaultSpacing
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Initializers
    // Инициализатор для перехода с MainView и с CollectionListView
    init(collection: CollectionModel) {
        self.totalPhotos = collection.totalPhotos ?? 0
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        getPhotos(collection: collection)
    }

    // Инициализатор для перехода с SearchView
    init(photos: [PhotoModel], totalPhotos: Int) {
        self.photos = photos
        self.totalPhotos = totalPhotos
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
        navigationController?.navigationBar.isHidden = false
        collectionView.backgroundColor = .white
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
                ErrorManager.showErrorDescription(error: error)
            }
        }
    }
}

// MARK: - Collection Data Source
extension PhotoListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionPhotosHeader.identifier,
            for: indexPath
        ) as? CollectionPhotosHeader else {
            return UICollectionReusableView()
        }
        
        header.delegate = self
        header.photoCountLabel.text = "Total photos: \(totalPhotos)"
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCell.identifier,
            for: indexPath
        ) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(photos[indexPath.item])
        
        return cell
    }
}

// MARK: - Collection Delegate
extension PhotoListViewController {
    
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = photos[indexPath.item]
        let onePhotoVC = OnePhotoViewController(photo: photo)
        
        // MARK: - Navigation
        navigationController?.pushViewController(onePhotoVC, animated: true)
    }
}

// MARK: - Collection View Layout
extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: UIConstant.photoListHeaderHeight)
    }
    
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
        return CGSize(width: sizeWidth, height: sizeWidth * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: edgeWidth, bottom: 0, right: edgeWidth)
    }
}

extension PhotoListViewController: CollectionPhotosHeaderDelegate {
    
    func switchColumnNumber(columns: Int) {
        numberOfColumns = CGFloat(columns)
        collectionView.reloadData()
    }
}
