//
//  CarouselTableCell.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

import UIKit

protocol CarouselTableCellDelegate: UIViewController {
    func searchCollections()
    func searchPhotos()
    func onCollectionTapped(collection: CollectionModel)
    func onPhotoTapped(photo: PhotoModel)
}

final class CarouselTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    static let identifier = String(describing: CarouselTableCell.self)
    
    weak var delegate: CarouselTableCellDelegate?
    
    private var contentType: ContentType!
    private var collections = [CollectionModel]()
    private var photos = [PhotoModel]()
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
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
    @IBAction func searchButtonTapped() {
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
        networkService.fetchCollections(count: UIConstants.countCarouselElements) {
            [weak self] result, _ in
            
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
        networkService.fetchRandomPhotos(count: UIConstants.countCarouselElements) {
            [weak self] result, _ in
            
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

// MARK: - Collection View Data Source
extension CarouselTableCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CarouselImageCell.identifier,
                for: indexPath) as? CarouselImageCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(photo: photos[indexPath.item])
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension CarouselTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        contentType == .photo
            ? delegate?.onPhotoTapped(photo: photos[indexPath.item])
            : delegate?.onCollectionTapped(collection: collections[indexPath.item])
    }
}
