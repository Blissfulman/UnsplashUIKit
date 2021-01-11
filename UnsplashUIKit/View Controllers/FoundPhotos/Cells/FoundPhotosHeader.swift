//
//  FoundPhotosHeader.swift
//  UnsplashUIKit
//
//  Created by User on 11.01.2021.
//

import UIKit

protocol FoundPhotosHeaderDelegate: UIViewController {
    func switchColumnNumber(columns: Int)
}

final class FoundPhotosHeader: UICollectionReusableView {

    // MARK: - Outlets
    @IBOutlet weak var photoCountLabel: UILabel!
    
    // MARK: - Properties
    static let identifier = String(describing: FoundPhotosHeader.self)
    
    weak var delegate: FoundPhotosHeaderDelegate?
        
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Actions
    @IBAction func segmentedControlSwitched(_ sender: UISegmentedControl) {
        delegate?.switchColumnNumber(columns: sender.selectedSegmentIndex + 1)
    }
}
