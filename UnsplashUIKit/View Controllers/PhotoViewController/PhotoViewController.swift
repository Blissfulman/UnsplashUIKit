//
//  PhotoViewController.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Properties
    let photo: PhotoModel!
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Initializers
    init(photo: PhotoModel) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: photo.urls?.regular ?? "") {
            photoImageView.image = networkService.fetchImage(fromURL: url)
        }
    }
}
