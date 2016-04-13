//
//  ComicViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 10/1/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import UIKit

class ComicViewController: UIViewController {
    
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var comic: Comic!
    var date: NSDate!
    let defaults = NSUserDefaults.standardUserDefaults()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initialize(comic: Comic, _ date: NSDate) {
        self.comic = comic
        self.date = date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.maximumZoomScale = 3.0
        if let image = comic?.image {
            self.comicImageView.image = image
        } else {
            spinner.color = .blackColor()
            spinner.hidesWhenStopped = true
            view.addSubview(spinner)
            spinner.startAnimating()
            let bounds = UIScreen.mainScreen().bounds
            spinner.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            comic?.onComplete = {
                self.comicImageView.image = self.comic?.image
                self.spinner.stopAnimating()
                self.updateConstraintsForSize(self.viewSizeWithoutInsets())
                self.updateMinZoomScaleForSize(self.viewSizeWithoutInsets())
            }
        }
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    override func viewDidAppear(animated: Bool) {
        defaults.setObject(date, forKey: "date")
        updateConstraintsForSize(viewSizeWithoutInsets())
        updateMinZoomScaleForSize(viewSizeWithoutInsets())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraintsForSize(viewSizeWithoutInsets())
        updateMinZoomScaleForSize(viewSizeWithoutInsets())
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        updateConstraintsForSize(viewSizeWithoutInsets())
    }
    
    
    // MARK: - Update Constraints
    
    private func viewSizeWithoutInsets() -> CGSize {
        var size = view.bounds.size
        size.height -= UIApplication.sharedApplication().statusBarFrame.size.height
        if let navController = self.navigationController {
            size.height -= navController.navigationBar.frame.size.height
        }
        return size
    }
    
    private func updateConstraintsForSize(size: CGSize) {
        let bounds = UIScreen.mainScreen().bounds
        spinner.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let yOffset = max(0, (size.height - comicImageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - comicImageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / comicImageView.bounds.width
        let heightScale = size.height / comicImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
}


extension ComicViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraintsForSize(viewSizeWithoutInsets())
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return comicImageView
    }
    
}

