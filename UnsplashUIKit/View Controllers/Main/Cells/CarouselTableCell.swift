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
    func onPhotoTapped(photo: PhotoModel)
    func onCollectionTapped(collection: CollectionModel)
}

final class CarouselTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    static let identifier = "carouselTableCell"
    
    weak var delegate: CarouselTableCellDelegate?
    
    private var photos = [PhotoModel]()
    private var collections = [CollectionModel]()
    private var contentType: ContentType!
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: "CarouselTableCell", bundle: nil)
    }
    
    // MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.register(CarouselImageCell.nib(),
                                forCellWithReuseIdentifier: CarouselImageCell.identifier)
    }
    
    // MARK: - Public methods
    func configure(contentType: ContentType) {
        self.contentType = contentType
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: UIConstant.defaultEdgeWidth,
                                                   bottom: 0, right: UIConstant.defaultEdgeWidth)
        
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
    
    private func fillCollectionCarousel() {
        networkService.fetchCollections { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let collections):
                self.collections = collections
                self.photos = collections.compactMap { $0.coverPhoto }
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
    
    private func fillPhotoCarousel() {
        networkService.fetchRandomPhotos(count: 10) { [weak self] result in
            
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
        cell.delegate = self
        cell.configure(photos[indexPath.item], itemIndex: indexPath.item)
        
        return cell
    }
}

extension CarouselTableCell: CarouselImageCellDelegate {
    
    func elementSelected(at itemIndex: Int) {
        contentType == .photo
            ? delegate?.onPhotoTapped(photo: photos[itemIndex])
            : delegate?.onCollectionTapped(collection: collections[itemIndex])
    }
}
