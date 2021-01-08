//
//  PhotoInfoViewController.swift
//  UnsplashUIKit
//
//  Created by User on 06.01.2021.
//

import UIKit

final class PhotoInfoViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorUsernameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var altDescriptionLabel: UILabel!
    
    // MARK: - Properties
    let photo: PhotoModel!
        
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
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        if let url = URL(string: photo.user?.profileImage?.medium ?? "") {
            authorImageView.loadImage(by: url)
        }
        authorImageView.layer.cornerRadius = authorImageView.frame.height / 2
        
        authorUsernameLabel.text = photo.user?.username
        if let date = photo.createdAt {
            createdDateLabel.text = DateFormatter.appDateFormatter.string(from: date)
        }
        if let width = photo.width, let height = photo.height {
            widthLabel.text = "\(width)"
            heightLabel.text = "\(height)"
        }
        locationLabel.text = photo.location?.city
        descriptionLabel.text = photo.description
        altDescriptionLabel.text = photo.altDescription
        print(photo.urls?.full ?? "No URL" )
    }
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true)
    }
}
