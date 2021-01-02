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
    
    // MARK: - Properties
    let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.getRandomPhoto { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case let .success(photo):
                guard let url = URL(string: photo.urls?.regular ?? "") else { return }
                
                self.imageView.image = self.networkService.getImage(fromURL: url)
                self.imageView.appearAnimation()
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
