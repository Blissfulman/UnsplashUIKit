//
//  UIImageView+Extension.swift
//  UnsplashUIKit
//
//  Created by User on 07.01.2021.
//

import UIKit

extension UIImageView {
    
    func loadImage(by url: URL) {
        let cache = URLCache.shared
        let request = URLRequest(url: url)

        if let imageData = cache.cachedResponse(for: request)?.data {
            image = UIImage(data: imageData)
        } else {
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                DispatchQueue.main.async {
                    guard let data = data, let response = response else {
                        return
                    }
                    let cacheRepsonse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cacheRepsonse, for: request)
                    self.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
