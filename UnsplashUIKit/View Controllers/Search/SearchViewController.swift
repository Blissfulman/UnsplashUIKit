//
//  SearchViewController.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private enum SearchOrderState: String {
        case relevant
        case latest
    }
    
    // MARK: - Outlets
    @IBOutlet weak var searchTermsTextField: UITextField!
    @IBOutlet weak var orderBySegmentedControl: UISegmentedControl!
    @IBOutlet weak var startSearchButton: CustomButton!
    
    // MARK: - Properties
    private let contentType: ContentType!
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    private var searchOrderState: SearchOrderState {
        orderBySegmentedControl.selectedSegmentIndex == 0 ? .relevant : .latest
    }
    
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
        
        searchTermsTextField.delegate = self
        setupUI()
    }
    
    // MARK: - Actions
    @IBAction func textFieldEditingChanged() {
        guard let searchTerms = searchTermsTextField.text else { return }
        
        startSearchButton.isEnabled = !searchTerms.isEmpty
    }
    
    @IBAction func startSearchButtonTapped() {
        view.endEditing(true)
        
        guard let query = searchTermsTextField.text,
              !query.isEmpty else { return }
        
        LoadingView.show(parentView: view)
        
        contentType == .photo
            ? searchPhotos(query: query, orderBy: searchOrderState.rawValue)
            : searchCollections(query: query, orderBy: searchOrderState.rawValue)
    }
    
    // MARK: - Private methods
    private func setupUI() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "Search \(contentType.rawValue)"
        
        startSearchButton.isEnabled = false
    }
    
    private func searchPhotos(query: String, orderBy: String) {
        networkService.searchPhotos(query: query, orderBy: orderBy) { [weak self] result in

            defer {
                LoadingView.hide()
            }
            
            guard let self = self else { return }
            
            switch result {
            case .success(let searchPhotosResult):
                guard searchPhotosResult.total != 0 else {
                    self.showEmptyResultAlert()
                    return
                }
                
                if let photos = searchPhotosResult.photos,
                   let totalPhotos = searchPhotosResult.total {
                    let photoListVC = PhotoListViewController(photos: photos,
                                                              totalPhotos: totalPhotos)
                    photoListVC.title = "Results for \"\(query)\""
                    
                    // MARK: - Navigation
                    self.navigationController?.pushViewController(photoListVC, animated: true)
                }
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    private func searchCollections(query: String, orderBy: String) {
        networkService.searchCollections(query: query, orderBy: orderBy) { [weak self] result in
            
            defer {
                LoadingView.hide()
            }
            
            guard let self = self else { return }

            switch result {
            case .success(let searchCollectionsResult):
                guard searchCollectionsResult.total != 0 else {
                    self.showEmptyResultAlert()
                    return
                }
                
                if let collections = searchCollectionsResult.collections,
                   let totalCollections = searchCollectionsResult.total {
                    let collectionListVC = CollectionListViewController(
                        collections: collections, totalCollections: totalCollections)
                    collectionListVC.title = "Results for \"\(query)\""

                    // MARK: - Navigation
                    self.navigationController?.pushViewController(collectionListVC, animated: true)
                }
            case .failure(let error):
                self.showAlert(error)
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
