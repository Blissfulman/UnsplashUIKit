//
//  CollectionPhotosViewController.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

import UIKit

final class CollectionPhotosViewController: UICollectionViewController {
    
    // MARK: - Properties
    /// Отображаемые (загруженные) фотографии.
    private var photos = [PhotoModel]()
    
    /// Общее количество фотографий в отображаемом списке.
    private let totalItems: Int
    
    private var numberOfColumns = UIConstant.defaultNumberOfColumns
    private let edgeWidth = UIConstant.defaultEdgeWidth
    private let spacing = UIConstant.defaultSpacing
    
    private var links: PaginationLinks?
    private let networkService: NetworkServiceProtocol = NetworkService()
    private let paginationService: PaginationServiceProtocol = PaginationService()
    
    // MARK: - Initializers
    // Инициализатор для перехода с MainView и с CollectionListView
    init(collection: CollectionModel) {
        self.totalItems = collection.totalPhotos ?? 0
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        loadFirstPage(collection: collection)
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
        collectionView.register(CollectionPhotoCell.nib(),
                                forCellWithReuseIdentifier: CollectionPhotoCell.identifier)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionView.backgroundColor = .white
    }
    
    // MARK: - Fetching data
    private func loadFirstPage(collection: CollectionModel) {
        
        guard let collectionID = collection.id else { return }
        
        networkService.fetchCollectionPhotos(id: collectionID) {
            [weak self] result, links in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let photos):
                self.photos = photos
                self.links = links
                self.collectionView.reloadData()
            case .failure(let error):
                ErrorManager.showErrorDescription(error: error)
            }
        }
    }
    
    // MARK: - Pagination
    private func loadNextPage() {
        guard let nextLink = links?[RelationLinkType.next],
              let url = nextLink else { return }
        
        paginationService.fetchCollectionPhotos(url: url) {
            [weak self] result, links in

            guard let self = self else { return }
            
            switch result {
            case .success(let photos):
                let indexPaths = self.getNextPageIndexPaths(
                    loadedItems: self.photos.count,
                    newItemsCount: photos.count
                )
                self.photos.append(contentsOf: photos)
                self.links = links
                self.collectionView.insertItems(at: indexPaths)
            case .failure(let error):
                self.showErrorAlert(error)
            }
        }
    }
}

// MARK: - Collection View Data Source
extension CollectionPhotosViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionPhotosHeader.identifier,
            for: indexPath
        ) as? CollectionPhotosHeader else {
            return UICollectionReusableView()
        }
        
        header.delegate = self
        header.photoCountLabel.text = "Total photos: \(totalItems)"
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionPhotoCell.identifier,
            for: indexPath
        ) as? CollectionPhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(photos[indexPath.item])
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension CollectionPhotosViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                
        if (totalItems > photos.count) && (photos.count - indexPath.row == 5) {
            print("Pagination loading...")
            loadNextPage()
        }
    }
    
    // MARK: - Navigation
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = photos[indexPath.item]
        let onePhotoVC = OnePhotoViewController(photo: photo)
        
        navigationController?.pushViewController(onePhotoVC, animated: true)
    }
}

// MARK: - Collection View Layout
extension CollectionPhotosViewController: UICollectionViewDelegateFlowLayout {
    
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
        return CGSize(width: sizeWidth, height: sizeWidth * UIConstant.photoCellSidesRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: edgeWidth, bottom: 0, right: edgeWidth)
    }
}

// MARK: - CollectionPhotosHeaderDelegate
extension CollectionPhotosViewController: CollectionPhotosHeaderDelegate {
    
    func switchColumnNumber(columns: Int) {
        numberOfColumns = CGFloat(columns)
        collectionView.reloadData()
    }
}
