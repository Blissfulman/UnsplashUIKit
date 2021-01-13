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
    static let identifier = String(describing: HeaderTableCell.self)
    
    // Хранение модели необходимо для открытия фотографии с MainView
    var photo: PhotoModel?
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Class methods
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadPhoto()
    }
    
    // MARK: - Fetching data
    private func loadPhoto() {
        networkService.fetchRandomPhotos(count: 1) { [weak self] result, _ in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let photos):
                guard let photo = photos.first,
                      let url = URL(string: photo.urls?.regular ?? "") else { return }
                self.photo = photo
                self.photoImageView.loadImage(by: url)
            case .failure(let error):
                ErrorManager.showErrorDescription(error: error)
            }
        }
    }
}
