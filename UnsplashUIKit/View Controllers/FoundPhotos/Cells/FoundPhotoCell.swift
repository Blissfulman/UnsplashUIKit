//
//  FoundPhotoCell.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 11.01.2021.
//

import UIKit

final class FoundPhotoCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Lifecycle methods
    override func prepareForReuse() {
        imageView.image = UIConstants.defaultImage
    }
    
    // MARK: - Public methods
    func configure(_ photo: PhotoModel) {
        layer.cornerRadius = UIConstants.defaultCornerRadius

        if let url = URL(string: photo.urls?.small ?? "") {
            imageView.loadImage(by: url)
        }
    }
}
