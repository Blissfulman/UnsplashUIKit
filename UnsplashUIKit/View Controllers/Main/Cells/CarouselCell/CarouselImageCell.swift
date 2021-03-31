//
//  CarouselImageCell.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 06.01.2021.
//

import UIKit

final class CarouselImageCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Lifeсycle methods
    override func prepareForReuse() {
        imageView.image = UIConstants.defaultImage
    }
    
    // MARK: - Public methods
    func configure(photo: PhotoModel) {        
        layer.cornerRadius = UIConstants.defaultCornerRadius

        if let url = URL(string: photo.urls?.small ?? "") {
            imageView.loadImage(by: url)
        }
    }
}
