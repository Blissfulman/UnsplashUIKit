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
    @IBOutlet weak var photoCountLabel: UILabel!
    
    // MARK: - Properties
    static let identifier = String(describing: CollectionPhotosHeader.self)
    
    weak var delegate: CollectionPhotosHeaderDelegate?
        
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Actions
    @IBAction func segmentedControlSwitched(_ sender: UISegmentedControl) {
        delegate?.switchColumnNumber(columns: sender.selectedSegmentIndex + 1)
    }
}
