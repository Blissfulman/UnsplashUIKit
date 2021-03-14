//
//  FoundPhotosViewController.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 11.01.2021.
//

import UIKit

final class FoundPhotosViewController: UICollectionViewController {
    
    // MARK: - Properties
    /// Отображаемые (загруженные) фотографии.
    private var photos = [PhotoModel]()
    
    /// Общее количество фотографий в отображаемом списке.
    private let totalItems: Int
    
    private var numberOfColumns = UIConstants.defaultNumberOfColumns
    private let edgeWidth = UIConstants.defaultEdgeWidth
    private let spacing = UIConstants.defaultSpacing
    
    private var links: PaginationLinks?
    private let paginationService: PaginationServiceProtocol = PaginationService()
    
    // MARK: - Initializers
    init(photos: [PhotoModel], totalItems: Int, links: PaginationLinks?) {
        self.photos = photos
        self.totalItems = totalItems
        self.links = links
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(
            FoundPhotosHeader.nib(),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FoundPhotosHeader.identifier
        )
        collectionView.register(FoundPhotoCell.nib(),
                                forCellWithReuseIdentifier: FoundPhotoCell.identifier)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionView.backgroundColor = .white
    }
    
    // MARK: - Pagination
    private func loadNextPage() {
        guard let nextLink = links?[RelationLinkType.next],
              let url = nextLink else { return }
        
        paginationService.searchPhotos(url: url) { [weak self] result, links in
            guard let self = self else { return }

            switch result {
            case .success(let searchPhotosResult):
                guard let photos = searchPhotosResult.photos else { return }
                
                let indexPaths = self.getNextPageIndexPaths(
                    loadedItems: self.photos.count,
                    newItemsCount: searchPhotosResult.photos?.count ?? 0
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
extension FoundPhotosViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FoundPhotosHeader.identifier,
            for: indexPath
        ) as? FoundPhotosHeader else {
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
            withReuseIdentifier: FoundPhotoCell.identifier,
            for: indexPath
        ) as? FoundPhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(photos[indexPath.item])
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension FoundPhotosViewController {
    
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
extension FoundPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: UIConstants.photoListHeaderHeight)
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
        return CGSize(width: sizeWidth, height: sizeWidth * UIConstants.photoCellSidesRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: edgeWidth, bottom: 0, right: edgeWidth)
    }
}

// MARK: - FoundPhotosHeaderDelegate
extension FoundPhotosViewController: FoundPhotosHeaderDelegate {
    
    func switchColumnNumber(columns: Int) {
        numberOfColumns = CGFloat(columns)
        collectionView.reloadData()
    }
}
