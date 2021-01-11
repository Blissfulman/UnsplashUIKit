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
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "defaultImage")
    }
    
    // MARK: - Public methods
    func configure(_ photo: PhotoModel) {
        layer.cornerRadius = UIConstant.defaultCornerRadius

        if let url = URL(string: photo.urls?.small ?? "") {
            imageView.loadImage(by: url)
        }
    }
}
