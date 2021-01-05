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
    
    // MARK: - Navigation
    @IBAction func showCollectionsButtonTapped(_ sender: UIButton) {
        let collectionListVC = CollectionListViewController()
        let navigationController = UINavigationController(rootViewController: collectionListVC)
        AppDelegate.shared.window?.rootViewController = navigationController
    }
    
    @IBAction func searchPhotosButtonTapped(_ sender: UIButton) {
        let searchPhotosVC = SearchPhotosViewController()
        let navigationController = UINavigationController(rootViewController: searchPhotosVC)
        AppDelegate.shared.window?.rootViewController = navigationController
    }
    
    // MARK: - Private methods
    private func setupUI() {
        networkService.fetchRandomPhoto { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let photo):
                if let url = URL(string: photo.urls?.regular ?? "") {
                    self.imageView.image = self.networkService.fetchImage(fromURL: url)

                    self.imageView.appearAnimation()
                    self.buttonsStackView.appearAnimation(duration: 2)
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
