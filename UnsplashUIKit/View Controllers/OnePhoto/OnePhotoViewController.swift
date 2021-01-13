//
//  OnePhotoViewController.swift
//  UnsplashUIKit
//
//  Created by User on 12.01.2021.
//

import UIKit

final class OnePhotoViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
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
                DispatchQueue.main.async {
                    BlockingView.hide()
                    guard let self = self else { return }

                    self.updateImageViewConstraints()
                    self.updateMinZoomScaleForSize()
                }
            }
        }
    }
    
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
        
        let infoButton = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(showPhotoInfo)
        )
        let openOriginalButton = UIBarButtonItem(
            title: "Open original",
            style: .plain,
            target: self,
            action: #selector(openOriginal)
        )
        navigationItem.rightBarButtonItems = [infoButton, openOriginalButton]
        
        likesLabel.text = "\(photo.likes ?? 0)"
        viewsLabel.text = "\(photo.views ?? 0)"
        downloadsLabel.text = "\(photo.downloads ?? 0)"
    }
    
    // MARK: - Private methods
    private func loadImage() {
        if let url = URL(string: photo.urls?.regular ?? "") {
            imageView.loadImage(by: url) { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }

                    self.updateImageViewConstraints()
                    self.updateMinZoomScaleForSize()
                }
            }
        }
    }
    
    private func setupGestureRecognizer() {
        let scrollViewDoubleTapGR = UITapGestureRecognizer(
            target: self, action: #selector(scrollViewDoubleTapped)
        )
        scrollViewDoubleTapGR.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(scrollViewDoubleTapGR)
    }
    
    // MARK: - Layout methods
    func updateMinZoomScaleForSize() {
        let size = scrollView.bounds.size
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minZoomScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minZoomScale
        scrollView.zoomScale = minZoomScale
        self.minZoomScale = minZoomScale
    }
    
    func updateImageViewConstraints() {
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

// MARK: - Scroll View Delegate
extension OnePhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageViewConstraints()
    }
}
