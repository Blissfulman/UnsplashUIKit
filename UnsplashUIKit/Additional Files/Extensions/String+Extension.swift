//
//  String+Extension.swift
//  UnsplashUIKit
//
//  Created by User on 10.01.2021.
//

import Foundation

extension String {
    
    // Необходимо для работы поиска с кириллицей
    func urlEncoded() -> String? {
        self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }
}
