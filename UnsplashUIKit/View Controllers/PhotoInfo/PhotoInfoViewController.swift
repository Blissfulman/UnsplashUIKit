//
//  PhotoInfoViewController.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 06.01.2021.
//

import UIKit

final class PhotoInfoViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var authorImageView: UIImageView!
    @IBOutlet private var authorNameLabel: UILabel!
    @IBOutlet private var createdDateLabel: UILabel!
    @IBOutlet private var widthLabel: UILabel!
    @IBOutlet private var heightLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var altDescriptionLabel: UILabel!
    
    // MARK: - Properties
    
    private let photo: PhotoModel
        
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
    
    // MARK: - Setup UI
    
    private func setupUI() {
        if let url = URL(string: photo.user?.profileImage?.medium ?? "") {
            authorImageView.loadImage(by: url)
        }
        authorImageView.layer.cornerRadius = authorImageView.frame.height / 2
        
        authorNameLabel.text = photo.user?.name
        if let date = photo.createdAt {
            createdDateLabel.text = DateFormatter.appLongDateFormatter.string(from: date)
        }
        if let width = photo.width, let height = photo.height {
            widthLabel.text = "\(width)"
            heightLabel.text = "\(height)"
        }
        locationLabel.text = photo.location?.city
        descriptionLabel.text = photo.description
        altDescriptionLabel.text = photo.altDescription
        print(photo.urls?.full ?? "No URL")
    }
    
    // MARK: - Navigation
    
    @IBAction private func backButtonTapped() {
        dismiss(animated: true)
    }
}
