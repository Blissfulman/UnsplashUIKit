//
//  FoundPhotosViewController.swift
//  UnsplashUIKit
//
//  Created by User on 11.01.2021.
//

import UIKit

final class FoundPhotosViewController: UICollectionViewController, PhotosCollectionViewControllerPaginable {
    
    // MARK: - Properties
    /// Отображаемые (загруженные) фотографии
    var photos = [PhotoModel]()
    
    /// Общее количество фотографий в отображаемом списке
    let totalItems: Int
    
    /// Количество загруженных страниц
    var loadedPages = 1
    
    private var numberOfColumns = UIConstant.defaultNumberOfColumns
    private let edgeWidth = UIConstant.defaultEdgeWidth
    private let spacing = UIConstant.defaultSpacing
    
    var links: PaginationLinks?
    private let networkService: NetworkServiceProtocol = NetworkService()
    let paginationService: PaginationServiceProtocol = PaginationService()
    
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
    
    // MARK: - Private methods
    private func setupUI() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionView.backgroundColor = .white
    }
}

// MARK: - Collection Data Source
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

// MARK: - Collection Delegate
extension FoundPhotosViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                
        let isNeedLoading = photos.count - indexPath.row == 5
        
        if isNeedLoading {
            print("Need loading...")
            loadNextPageFoundPhotos(forSection: 0)
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

extension FoundPhotosViewController: FoundPhotosHeaderDelegate {
    
    func switchColumnNumber(columns: Int) {
        numberOfColumns = CGFloat(columns)
        collectionView.reloadData()
    }
}
