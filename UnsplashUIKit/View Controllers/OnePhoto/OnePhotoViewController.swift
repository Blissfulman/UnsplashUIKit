//
//  OnePhotoViewController.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 12.01.2021.
//

import UIKit

final class OnePhotoViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var viewsLabel: UILabel!
    @IBOutlet private weak var downloadsLabel: UILabel!
    
    @IBOutlet private weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private let photo: PhotoModel
    /// Минимальное значение масштабирования ScrollView для загруженной фотографии. Обновляется после загрузки фотографии.
    private var minZoomScale: CGFloat = 1
    
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
        loadImage()
        setupUI()
        setupGestureRecognizer()
    }
    
    // MARK: - Actions
    
    @objc func showPhotoInfo() {
        let photoInfoVC = PhotoInfoViewController(photo: photo)
        present(photoInfoVC, animated: true)
    }
    
    @objc func openOriginal() {
        scrollView.setZoomScale(minZoomScale, animated: true)
        BlockingView.show(parentView: view)
        
        if let url = URL(string: photo.urls?.full ?? "") {
            imageView.loadImage(by: url) { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    BlockingView.hide()
                    self.updateImageViewConstraints()
                    self.updateMinZoomScale()
                }
            }
        }
    }
    
    // Изменение масштаба фотографии по двойному тапу
    @objc private func scrollViewDoubleTapped() {
        switch scrollView.zoomScale {
        case minZoomScale:
            scrollView.setZoomScale(minZoomScale * 2, animated: true)
        case minZoomScale * 2:
            scrollView.setZoomScale(minZoomScale * 3, animated: true)
        default:
            scrollView.setZoomScale(minZoomScale, animated: true)
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(showPhotoInfo))
        let openOriginalButton = UIBarButtonItem(title: "Open original",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(openOriginal))
        navigationItem.rightBarButtonItems = [infoButton, openOriginalButton]
        
        likesLabel.text = "\(photo.likes ?? 0)"
        viewsLabel.text = "\(photo.views ?? 0)"
        downloadsLabel.text = "\(photo.downloads ?? 0)"
    }
    
    // MARK: - Private methods
    
    private func loadImage() {
        if let url = URL(string: photo.urls?.regular ?? "") {
            imageView.loadImage(by: url) { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.updateImageViewConstraints()
                    self.updateMinZoomScale()
                    self.scrollView.isUserInteractionEnabled = true
                    self.imageView.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func setupGestureRecognizer() {
        let scrollViewDoubleTapGR = UITapGestureRecognizer(target: self, action: #selector(scrollViewDoubleTapped))
        scrollViewDoubleTapGR.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(scrollViewDoubleTapGR)
    }
    
    // MARK: - Layout methods
    
    /// Обновление минимального значения масштабирования ScrollView для текущей фотографии.
    private func updateMinZoomScale() {
        let size = scrollView.bounds.size
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minZoomScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minZoomScale
        scrollView.zoomScale = minZoomScale
        self.minZoomScale = minZoomScale
    }
    
    /// Обновление констрейнтов ImageView для текущей фотографии.
    private func updateImageViewConstraints() {
        let size = scrollView.bounds.size
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
}

// MARK: - Scroll view delegate
extension OnePhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageViewConstraints()
    }
}
