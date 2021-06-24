//
//  CarouselTableCell.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 05.01.2021.
//

import UIKit

// MARK: - Protocols

protocol CarouselTableCellDelegate: AnyObject {
    func searchCollections()
    func searchPhotos()
    func onCollectionTapped(collection: CollectionModel)
    func onPhotoTapped(photo: PhotoModel)
}

final class CarouselTableCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var searchButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    weak var delegate: CarouselTableCellDelegate?
    
    private var contentType: ContentType!
    private var collections = [CollectionModel]()
    private var photos = [PhotoModel]()
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CarouselImageCell.nib(),
                                forCellWithReuseIdentifier: CarouselImageCell.identifier)
    }
    
    // MARK: - Public methods
    
    func configure(contentType: ContentType) {
        self.contentType = contentType
        
        selectionStyle = .none
        collectionView.contentInset = UIEdgeInsets(top: 0, left: UIConstants.defaultEdgeWidth,
                                                   bottom: 0, right: UIConstants.defaultEdgeWidth)
        
        titleLabel.text = contentType.rawValue.capitalized
        searchButton.setTitle("Search \(contentType.rawValue)", for: .normal)
        
        setupCarouselCells()
    }
    
    // MARK: - Actions
    
    @IBAction private func searchButtonTapped() {
        contentType == .collection
            ? delegate?.searchCollections()
            : delegate?.searchPhotos()
    }
    
    // MARK: - Private methods
    
    private func setupCarouselCells() {
        contentType == .collection
            ? fillCollectionCarousel()
            : fillPhotoCarousel()
    }
    
    // MARK: - Fetching data
    
    private func fillCollectionCarousel() {
        networkService.fetchCollections(count: UIConstants.countCarouselElements) { [weak self] result, _ in
            guard let self = self else { return }
            
            switch result {
            case .success(let collections):
                self.collections = collections
                self.photos = collections.compactMap { $0.coverPhoto }
                self.collectionView.reloadData()
            case .failure(let error):
                ErrorManager.showErrorDescription(error: error)
            }
        }
    }
    
    private func fillPhotoCarousel() {
        networkService.fetchRandomPhotos(count: UIConstants.countCarouselElements) { [weak self] result, _ in
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

// MARK: - Collection view data source

extension CarouselTableCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CarouselImageCell.identifier,
            for: indexPath
        ) as? CarouselImageCell else { return UICollectionViewCell() }
        
        cell.configure(photo: photos[indexPath.item])
        return cell
    }
}

// MARK: - Collection view delegate

extension CarouselTableCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        contentType == .photo
            ? delegate?.onPhotoTapped(photo: photos[indexPath.item])
            : delegate?.onCollectionTapped(collection: collections[indexPath.item])
    }
}
