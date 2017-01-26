//
//  EcommerceProductDetailsViewController.swift
//  EcommerceApp
//
//  Created by Florian Marcu on 1/22/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Material
import UIKit

private let reuseIdentifier = "ImageCollectionViewCell"

class EcommerceProductDetailsViewController: UIViewController {
    var product: Product? {
        didSet {
            self.view.setNeedsLayout()
        }
    }

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var detailsTextView: UITextView!
    @IBOutlet var addToCartButton: RaisedButton!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var contentViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let images = product?.productImages {
            pageControl.numberOfPages = images.count
        }

        addToCartButton.addTarget(self, action: #selector(handleAddToCartButton), for: .touchUpInside)
        addToCartButton.pulseColor = .white
        addToCartButton.backgroundColor = Color.green.base
        addToCartButton.titleColor = .white
        addToCartButton.layer.cornerRadius = 20

        updateContentViewHeight()
        prepareNavigationItem()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.detailsTextView.text = product?.productDescription

        let contentSize = self.detailsTextView.sizeThatFits(self.detailsTextView.bounds.size)
        var frame = self.detailsTextView.frame
        frame.size.height = contentSize.height
        self.detailsTextView.frame = frame

        updateContentViewHeight()
    }

    @objc
    fileprivate func handleAddToCartButton() {

    }

    fileprivate func updateContentViewHeight() {
        let orientation = UIDevice.current.orientation
        let constant: CGFloat = self.detailsTextView.frame.size.height + ((orientation == .portrait) ? 550 : 450)
        if contentViewHeightConstraint.constant != constant {
            contentViewHeightConstraint.constant = constant
            self.contentView.setNeedsLayout()
        }
    }

    fileprivate func prepareNavigationItem() {
        let closeButton = IconButton(image: Icon.cm.close)
        closeButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        navigationItem.title = product?.productName
        navigationItem.rightViews = [closeButton]
    }

    @objc
    fileprivate func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EcommerceProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = product?.productImages else {
            return 0
        }
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.configureCell(imageUrl: product?.productImages?[indexPath.row])
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.collectionView.frame.size.width
        pageControl.currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
    }
}