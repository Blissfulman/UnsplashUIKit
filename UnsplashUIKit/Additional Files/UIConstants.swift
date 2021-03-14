//
//  UIConstants.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 07.01.2021.
//

import UIKit

enum UIConstants {
    
    // Only for Main view
    static let mainViewHeaderHeight: CGFloat = 350
    static let mainViewCarouselHeight: CGFloat = 250
    static let countCarouselElements = 10
    
    // For many views
    static let photoListHeaderHeight: CGFloat = 56
    static let collectionListHeaderHeight: CGFloat = 40
    static let photoCellSidesRatio: CGFloat = 0.7
    static let collectionCellSidesRatio: CGFloat = 3.5
    
    static let defaultNumberOfColumns: CGFloat = 2
    static let defaultEdgeWidth: CGFloat = 10
    static let defaultSpacing: CGFloat = 3
    static let defaultCornerRadius: CGFloat = 8
    
    static let defaultImage = UIImage(named: "defaultImage")
}
