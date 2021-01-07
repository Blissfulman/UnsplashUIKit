//
//  SearchViewController.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchTermsTextField: UITextField!
    @IBOutlet weak var orderBySegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    private let contentType: ContentType!
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    // MARK: - Initializers
    init(contentType: ContentType) {
        self.contentType = contentType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search \(contentType.rawValue)"
        searchTermsTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    @IBAction func startSearchButtonTapped() {
        view.endEditing(true)
        search()
    }
    
    // MARK: - Private methods
    private func search() {
        guard let query = searchTermsTextField.text,
              !query.isEmpty else { return }
        
        let orderBy = orderBySegmentedControl.selectedSegmentIndex == 0
            ? "relevant" : "latest"
        
        contentType == .photo
            ? networkService.searchPhotos(query: query, orderBy: orderBy) { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let searchPhotosResult):
                    if let photos = searchPhotosResult.photos,
                       let totalPhotos = searchPhotosResult.total {
                        let photoListVC = PhotoListViewController(photos: photos,
                                                                  totalPhotos: totalPhotos)
                        photoListVC.title = "Results for \"\(query)\""
                        
                        // MARK: - Navigation
                        self.navigationController?.pushViewController(photoListVC, animated: true)
                    }
                case .failure(let error):
                    if let serverError = error as? ServerError {
                        print(serverError.rawValue)
                        return
                    }
                    print(error.localizedDescription)
                }
            }
            : networkService.searchCollections(query: query, orderBy: orderBy) { [weak self] result in
                
                guard let self = self else { return }

                switch result {
                case .success(let searchCollectionsResult):
                    if let collections = searchCollectionsResult.collections {
                        let collectionListVC = CollectionListViewController(collections: collections)
                        collectionListVC.title = "Results for \"\(query)\""

                        // MARK: - Navigation
                        self.navigationController?.pushViewController(collectionListVC, animated: true)
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
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        startSearchButtonTapped()
        return true
    }
}
