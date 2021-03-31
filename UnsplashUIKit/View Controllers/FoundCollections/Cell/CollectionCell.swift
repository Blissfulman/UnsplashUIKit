//
//  CollectionCell.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 08.01.2021.
//

import UIKit

final class CollectionCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private var previewPhotoImageViews: [UIImageView]!
    @IBOutlet private weak var collectionTitleLabel: UILabel!
    @IBOutlet private weak var totalPhotosLabel: UILabel!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    
    // MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryType = .disclosureIndicator
        previewPhotoImageViews.forEach { $0.layer.cornerRadius = UIConstants.defaultCornerRadius }
    }
    
    override func prepareForReuse() {
        previewPhotoImageViews.forEach { $0.image = UIImage(named: "defaultImage") }
    }
    
    // MARK: - Public methods
    func configure(_ collection: CollectionModel) {
        collectionTitleLabel.text = collection.title
        totalPhotosLabel.text = "\(collection.totalPhotos ?? 0)"
        userNameLabel.text = collection.user?.name
        if let date = collection.publishedAt {
            publishedDateLabel.text = DateFormatter.appShortDateFormatter.string(from: date)
        }
        
        previewPhotoImageViews.enumerated().forEach { index, imageView in
            
            guard let countImages = collection.previewPhotos?.count else { return }
            
            // Если коллекция пустая, то убираются картинки по умолчанию
            if countImages == 0 {
                previewPhotoImageViews.forEach { $0.image = nil }
            }
            
            if index < countImages, let url = URL(string: collection.previewPhotos?[index].urls?.thumb ?? "") {
                imageView.loadImage(by: url)
            } else {
                // Если фотографий в коллекции меньше 4
                imageView.image = nil
            }
        }
    }
}
