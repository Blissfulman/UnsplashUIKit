//
//  CollectionPhotosHeader.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

import UIKit

protocol CollectionPhotosHeaderDelegate: UIViewController {
    func switchColumnNumber(columns: Int)
}

final class CollectionPhotosHeader: UICollectionReusableView {

    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoCountLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    static let identifier = "collectionPhotosHeader"
    
    weak var delegate: CollectionPhotosHeaderDelegate?
        
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: "CollectionPhotosHeader", bundle: nil)
    }
    
    // MARK: - Public methods
    func configure(_ collection: CollectionModel?) {
        backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.15)
        
        descriptionLabel.text = collection?.description
        if let count = collection?.totalPhotos {
            photoCountLabel.text = "Total photos: \(count)"
        }
    }
    
    // MARK: - Actions
    @IBAction func segmentedControlSwitched(_ sender: Any) {
        delegate?.switchColumnNumber(columns: segmentedControl.selectedSegmentIndex + 1)
    }
}
