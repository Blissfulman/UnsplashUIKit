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
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    
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
        
        navigationController?.navigationBar.isHidden = false
        setupUI()
        fetchImage()
    }
    
    @objc func showPhotoInfo() {
        let photoInfoVC = PhotoInfoViewController(photo: photo)
        present(photoInfoVC, animated: true)
    }
    
    // MARK: - Private methods
    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(showPhotoInfo)
        )
        
        let likes = photo.likes ?? 0
        likesLabel.text = "\(likes)"
        
        let views = photo.views ?? 0
        viewsLabel.text = "\(views)"
        
        let downloads = photo.downloads ?? 0
        downloadsLabel.text = "\(downloads)"
    }
    
    private func fetchImage() {
        if let url = URL(string: photo.urls?.regular ?? "") {
            photoImageView.image = networkService.fetchImage(fromURL: url)
        }
    }
}
