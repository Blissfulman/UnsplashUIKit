//
//  CollectionListCell.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import UIKit

final class CollectionListCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    static let identifier = "collectionCell"

    let networkService: NetworkServiceProtocol = NetworkService()
    
    static func nib() -> UINib {
        UINib(nibName: "CollectionListCell", bundle: nil)
    }
    
    func configure(_ collection: Collection) {
        if let url = URL(string: collection.coverPhoto?.urls?.small ?? "") {
            imageView.image = networkService.getImage(fromURL: url)
        }
        collectionNameLabel.text = collection.title
    }

}
