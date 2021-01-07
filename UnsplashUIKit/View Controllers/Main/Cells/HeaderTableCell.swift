//
//  HeaderTableCell.swift
//  UnsplashUIKit
//
//  Created by User on 06.01.2021.
//

import UIKit

final class HeaderTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Properties
    static let identifier = "headerTableCell"
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: "HeaderTableCell", bundle: nil)
    }
    
    // MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        getPhoto()
    }
    
    // MARK: - Private methods
    private func getPhoto() {
        networkService.fetchRandomPhotos(count: 1) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let photos):
                if let url = URL(string: photos.first?.urls?.regular ?? "") {
                    self.photoImageView.loadImage(by: url)
                }
            case .failure(let error):
                if let serverError = error as? ServerError {
                    print(serverError.rawValue)
                    return
                }
                print(error.localizedDescription)
            }
        }
    }
}
