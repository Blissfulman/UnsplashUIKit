//
//  UICollectionViewController+Extension.swift
//  UnsplashUIKit
//
//  Created by User on 08.01.2021.
//

import UIKit

extension UICollectionViewController {
    
    /// Расчёт ширины ячейки коллекции на основе переданных данных.
    /// - Parameters:
    ///   - spacing: Горизонтальный spacing коллекции.
    ///   - edgeWidth: Ширина горизонтальной границы коллекции с родительским вью.
    ///   - numberOfColumns: Количество колонок коллекции.
    /// - Returns: Возвращает значение ширины.
    func calculateSizeWidth(spacing: CGFloat,
                            edgeWidth: CGFloat,
                            numberOfColumns: CGFloat) -> CGFloat {
        
        let collectionWidth = collectionView.bounds.width
        let totalSpacingWidth = (spacing * (numberOfColumns - 1)) + edgeWidth * 2
        return (collectionWidth - totalSpacingWidth) / numberOfColumns
    }
}
