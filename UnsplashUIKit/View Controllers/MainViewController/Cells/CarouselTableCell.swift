//
//  CarouselTableCell.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

import UIKit

final class CarouselTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    static let identifier = "carouselTableCell"
    
    private var photos = [PhotoModel]()
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: "CarouselTableCell", bundle: nil)
    }
    
    // MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        collectionView.dataSource = self
        collectionView.register(CarouselImageCell.nib(),
                                forCellWithReuseIdentifier: CarouselImageCell.identifier)
    }
    
    // MARK: - Public methods
    func configure(type: CarouselCellType) {
        titleLabel.text = type.rawValue.capitalized
        searchButton.setTitle("Search \(type.rawValue)", for: .normal)
        
        type == .collections
            ? networkService.fetchCollections { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let collections):
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
            : networkService.fetchRandomPhotos(count: 10) { [weak self] result in
                
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
        cell.configure(photos[indexPath.item])
        return cell
    }
}
