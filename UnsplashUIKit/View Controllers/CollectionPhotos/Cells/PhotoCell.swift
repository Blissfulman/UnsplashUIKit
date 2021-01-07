//
//  PhotoCell.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    static let identifier = "photoCell"
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: "PhotoCell", bundle: nil)
    }
    
    // MARK: - Public methods
    func configure(_ photo: PhotoModel) {
        layer.cornerRadius = UIConstant.defaultCornerRadius

        if let url = URL(string: photo.urls?.small ?? "") {
            imageView.loadImage(by: url)
        }
    }
}
