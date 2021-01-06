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
    
    weak var delegate: CarouselTableCellDelegate?
    
    private var photo: PhotoModel!
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: "CarouselImageCell", bundle: nil)
    }
    
    // MARK: - Lifeсycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestureRecognizer()
    }
    
    // MARK: - Public methods
    func configure(_ photo: PhotoModel) {
        self.photo = photo
        layer.cornerRadius = 10

        if let url = URL(string: photo.urls?.small ?? "") {
            imageView.image = networkService.fetchImage(fromURL: url)
        }
    }
    
    // MARK: - Actions
    @objc func onPhotoTapped() {
        delegate?.onPhotoTapped(photo: photo)
    }
    
    // MARK: - Private methods
    private func setupGestureRecognizer() {
        let onPhotoTappedGR = UITapGestureRecognizer(target: self,
                                                     action: #selector(onPhotoTapped))
        imageView.addGestureRecognizer(onPhotoTappedGR)
    }
}
