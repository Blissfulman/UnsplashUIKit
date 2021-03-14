//
//  FoundPhotosHeader.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 11.01.2021.
//

import UIKit

protocol FoundPhotosHeaderDelegate: UIViewController {
    func switchColumnNumber(columns: Int)
}

final class FoundPhotosHeader: UICollectionReusableView {

    // MARK: - Outlets
    @IBOutlet weak var photoCountLabel: UILabel!
    
    // MARK: - Properties    
    weak var delegate: FoundPhotosHeaderDelegate?
    
    // MARK: - Actions
    @IBAction func segmentedControlSwitched(_ sender: UISegmentedControl) {
        delegate?.switchColumnNumber(columns: sender.selectedSegmentIndex + 1)
    }
}
