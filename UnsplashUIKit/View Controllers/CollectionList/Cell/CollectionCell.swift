//
//  CollectionCell.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import UIKit

final class CollectionCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    // MARK: - Properties
    static let identifier = "collectionCell"

    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: "CollectionCell", bundle: nil)
    }
    
    // MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8
        collectionNameLabel.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }
    
    // MARK: - Public methods
    func configure(_ collection: CollectionModel) {
        if let url = URL(string: collection.coverPhoto?.urls?.small ?? "") {
            imageView.image = networkService.fetchImage(fromURL: url)
        }
        collectionNameLabel.text = collection.title
    }
}