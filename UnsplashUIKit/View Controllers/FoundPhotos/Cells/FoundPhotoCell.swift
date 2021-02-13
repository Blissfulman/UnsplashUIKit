//
//  FoundPhotoCell.swift
//  UnsplashUIKit
//
//  Created by User on 11.01.2021.
//

import UIKit

final class FoundPhotoCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    static let identifier = String(describing: FoundPhotoCell.self)
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
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
