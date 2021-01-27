//
//  SearchViewController.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Nested types
    private enum SearchOrderState: String {
        case relevant
        case latest
    }
    
    // MARK: - Outlets
    @IBOutlet weak var searchTermsTextField: UITextField!
    @IBOutlet weak var orderBySegmentedControl: UISegmentedControl!
    @IBOutlet weak var startSearchButton: CustomButton!
    
    // MARK: - Properties
    private let contentType: ContentType
    
    private var searchOrderState: SearchOrderState {
        orderBySegmentedControl.selectedSegmentIndex == 0 ? .relevant : .latest
    }
    
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
        
        contentType == .photo
            ? searchPhotos(query: query, orderBy: searchOrderState.rawValue)
            : searchCollections(query: query, orderBy: searchOrderState.rawValue)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "Search \(contentType.rawValue)"
        
        startSearchButton.isEnabled = false
    }
    
    // MARK: - Fetching data
    private func searchPhotos(query: String, orderBy: String) {
        
        BlockingView.show(parentView: view)
        
        networkService.searchPhotos(query: query, orderBy: orderBy) { [weak self] result, links in
            
            defer {
                BlockingView.hide()
            }
            
            guard let self = self else { return }
            
            switch result {
            case .success(let searchPhotosResult):
                guard searchPhotosResult.total != 0 else {
                    self.showEmptyResultAlert()
                    return
                }
                
                if let photos = searchPhotosResult.photos,
                   let totalItems = searchPhotosResult.total {
                    let foundPhotosVC = FoundPhotosViewController(
                        photos: photos, totalItems: totalItems, links: links
                    )
                    foundPhotosVC.title = "Results for \"\(query)\""
                    
                    // MARK: - Navigation
                    self.navigationController?.pushViewController(foundPhotosVC, animated: true)
                }
            case .failure(let error):
                self.showErrorAlert(error)
            }
        }
    }
    
    private func searchCollections(query: String, orderBy: String) {

        BlockingView.show(parentView: view)
        
        networkService.searchCollections(query: query, orderBy: orderBy) {
            [weak self] result, links in
            
            defer {
                BlockingView.hide()
            }
            
            guard let self = self else { return }
            
            switch result {
            case .success(let searchCollectionsResult):
                guard searchCollectionsResult.total != 0 else {
                    self.showEmptyResultAlert()
                    return
                }
                
                if let collections = searchCollectionsResult.collections,
                   let totalItems = searchCollectionsResult.total {
                    let foundCollectionsVC = FoundCollectionsViewController(
                        collections: collections, totalItems: totalItems, links: links
                    )
                    foundCollectionsVC.title = "Results for \"\(query)\""

                    // MARK: - Navigation
                    self.navigationController?.pushViewController(foundCollectionsVC, animated: true)
                }
            case .failure(let error):
                self.showErrorAlert(error)
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
