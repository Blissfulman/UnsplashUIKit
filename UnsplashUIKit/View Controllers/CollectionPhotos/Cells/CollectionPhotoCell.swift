//
//  CollectionPhotoCell.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 04.01.2021.
//

import UIKit

final class CollectionPhotoCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - Lifecycle methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIConstants.defaultImage
    }
    
    // MARK: - Public methods
    
    func configure(_ photo: PhotoModel) {
        setCornerRadius(UIConstants.defaultCornerRadius)
        
        if let url = URL(string: photo.urls?.small ?? "") {
            imageView.loadImage(by: url)
        }
    }
}
