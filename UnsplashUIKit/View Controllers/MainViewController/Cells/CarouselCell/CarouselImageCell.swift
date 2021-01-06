//
//  CarouselImageCell.swift
//  UnsplashUIKit
//
//  Created by User on 06.01.2021.
//

import UIKit

final class CarouselImageCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    static let identifier = "carouselImageCell"
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: "CarouselImageCell", bundle: nil)
    }
    
    // MARK: - Public methods
    func configure(_ photo: PhotoModel) {
        layer.cornerRadius = 10

        if let url = URL(string: photo.urls?.small ?? "") {
            imageView.image = networkService.fetchImage(fromURL: url)
        }
    }
}
