//
//  MainViewController.swift
//  UnsplashUIKit
//
//  Created by User on 02.01.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        tabBarItem.image = UIImage(systemName: "photo")
        tabBarItem.title = "Welcome to Unsplash!"
        
        networkService.getRandomPhoto { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case let .success(photo):
                if let url = URL(string: photo.urls?.regular ?? "") {
                    self.imageView.image = self.networkService.getImage(fromURL: url)

                    self.imageView.appearAnimation()
                    self.buttonsStackView.appearAnimation(duration: 2)
                }
            case let .failure(error):
                if let serverError = error as? ServerError {
                    print(serverError.rawValue)
                    return
                }
                print(error.localizedDescription)
            }
        }
    }
}
