//
//  PhotoCell.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "photoCell"

    let networkService: NetworkServiceProtocol = NetworkService()
    
    static func nib() -> UINib {
        UINib(nibName: "PhotoCell", bundle: nil)
    }
        
    func configure(_ photo: Photo) {
        if let url = URL(string: photo.urls?.small ?? "") {
            imageView.image = networkService.getImage(fromURL: url)
        }
        imageView.backgroundColor = .yellow
    }
}
