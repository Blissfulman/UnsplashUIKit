//
//  PhotoInfoViewController.swift
//  UnsplashUIKit
//
//  Created by User on 06.01.2021.
//

import UIKit

final class PhotoInfoViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
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
        if let width = photo.width,
           let height = photo.height {
            widthLabel.text = "Width: \(width)"
            heightLabel.text = "Height: \(String(describing: height))"
        }
        
        if let description = photo.description, !description.isEmpty {
            descriptionLabel.text = "Description: " + description
        }
        
        if let altDescription = photo.altDescription, !altDescription.isEmpty {
            altDescriptionLabel.text = "Alternative description: " + altDescription
        }
    }
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true)
    }
}
