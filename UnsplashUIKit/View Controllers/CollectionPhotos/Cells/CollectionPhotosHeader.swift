//
//  CollectionPhotosHeader.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 04.01.2021.
//

import UIKit

protocol CollectionPhotosHeaderDelegate: class {
    func switchColumnNumber(columns: Int)
}

final class CollectionPhotosHeader: UICollectionReusableView {

    // MARK: - Outlets
    
    @IBOutlet private weak var photoCountLabel: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: CollectionPhotosHeaderDelegate?
    
    // MARK: - Public methods
    
    func configure(photoCount: Int) {
        photoCountLabel.text = "Total photos: \(photoCount)"
    }
    
    // MARK: - Actions
    
    @IBAction private func segmentedControlSwitched(_ sender: UISegmentedControl) {
        delegate?.switchColumnNumber(columns: sender.selectedSegmentIndex + 1)
    }
}
