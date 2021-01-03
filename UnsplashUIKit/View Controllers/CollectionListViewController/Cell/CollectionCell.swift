//
//  CollectionCell.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import UIKit

final class CollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    static let identifier = "collectionCell"

    let networkService: NetworkServiceProtocol = NetworkService()
    
    static func nib() -> UINib {
        UINib(nibName: "CollectionCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 12
        collectionNameLabel.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }
    
    func configure(_ collection: Collection) {
        if let url = URL(string: collection.coverPhoto?.urls?.small ?? "") {
            imageView.image = networkService.getImage(fromURL: url)
        }
        collectionNameLabel.text = collection.title
    }
}
