//
//  SearchPhotosViewController.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

import UIKit

final class SearchPhotosViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchTermsTextField: UITextField!
    @IBOutlet weak var orderBySegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTermsTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    @IBAction func startSearchButtonTapped() {
        view.endEditing(true)
        searchPhotos()
    }
    
    // MARK: - Private methods
    private func searchPhotos() {
        guard let query = searchTermsTextField.text,
              !query.isEmpty else { return }
        
        let orderBy = orderBySegmentedControl.selectedSegmentIndex == 0
            ? "relevant" : "latest"
        
        networkService.searchPhotos(query: query, orderBy: orderBy) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let searchPhotosResult):
                if let photos = searchPhotosResult.photos {
                    let photosVC = CollectionPhotosViewController(photos: photos)
                    
                    // MARK: - Navigation
                    self.navigationController?.pushViewController(photosVC, animated: true)
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
    
    // Скрытие клавиатуры по тапу в свободное место вью
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}

// MARK: - Text Field Delegate
extension SearchPhotosViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        startSearchButtonTapped()
        return true
    }
}
