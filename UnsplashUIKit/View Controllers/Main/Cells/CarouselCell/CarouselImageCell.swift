//
//  CarouselImageCell.swift
//  UnsplashUIKit
//
//  Created by User on 06.01.2021.
//

import UIKit

protocol CarouselImageCellDelegate: UITableViewCell {
    func elementSelected(at itemIndex: Int)
}

final class CarouselImageCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    static let identifier = "carouselImageCell"
    
    weak var delegate: CarouselImageCellDelegate?
    
    private var photo: PhotoModel!
    private var itemIndex: Int!
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: "CarouselImageCell", bundle: nil)
    }
    
    // MARK: - Lifeсycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestureRecognizer()
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "defaultImage")
    }
    
    // MARK: - Public methods
    func configure(_ photo: PhotoModel, itemIndex: Int) {
        self.photo = photo
        self.itemIndex = itemIndex
        
        layer.cornerRadius = UIConstant.defaultCornerRadius

        if let url = URL(string: photo.urls?.small ?? "") {
            imageView.loadImage(by: url)
        }
    }
    
    // MARK: - Actions
    @objc func onImageTapped() {
        delegate?.elementSelected(at: itemIndex)
    }
    
    // MARK: - Private methods
    private func setupGestureRecognizer() {
        let onPhotoTappedGR = UITapGestureRecognizer(target: self,
                                                     action: #selector(onImageTapped))
        imageView.addGestureRecognizer(onPhotoTappedGR)
    }
}
