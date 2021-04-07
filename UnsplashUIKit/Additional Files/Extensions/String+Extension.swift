//
//  String+Extension.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 10.01.2021.
//

import Foundation

extension String {
    
    // Необходимо для работы поиска с кириллицей
    func urlEncoded() -> String? {
        self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }
    
    /// Декодирование ссылок пагинации по regex pattern.
    func decodeToPaginationURLs(regexPattern: String) -> PaginationLinks {
        let groups = self.groupLinksData(for: regexPattern)
        
        var result = PaginationLinks()
        
        groups.forEach { group in
            if let first = group.first,
               let last = group.last {
                guard let relationLinkType = RelationLinkType.init(rawValue: last) else { return }
                result.updateValue(URL(string: first), forKey: relationLinkType)
            }
        }
        return result
    }
    
    /// Группировка полей ссылок пагинации по regex pattern.
    private func groupLinksData(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                (1..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
