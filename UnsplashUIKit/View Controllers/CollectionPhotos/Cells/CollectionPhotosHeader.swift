//
//  CollectionPhotosHeader.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 04.01.2021.
//

import UIKit

protocol CollectionPhotosHeaderDelegate: UIViewController {
    func switchColumnNumber(columns: Int)
}

final class CollectionPhotosHeader: UICollectionReusableView {

    // MARK: - Outlets
    @IBOutlet weak var photoCountLabel: UILabel!
    
    // MARK: - Properties    
    weak var delegate: CollectionPhotosHeaderDelegate?
    
    // MARK: - Actions
    @IBAction func segmentedControlSwitched(_ sender: UISegmentedControl) {
        delegate?.switchColumnNumber(columns: sender.selectedSegmentIndex + 1)
    }
}
