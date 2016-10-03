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
    var date: Date!
    let defaults = UserDefaults.standard
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initialize(_ comic: Comic) {
        self.comic = comic
        self.date = comic.date as Date!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = comic?.image {
            self.comicImageView.image = image
            self.updateConstraintsForSize(self.viewSizeWithoutInsets())
            self.updateMinZoomScaleForSize(self.viewSizeWithoutInsets())
        } else {
            spinner.color = .black
            spinner.hidesWhenStopped = true
            view.addSubview(spinner)
            spinner.startAnimating()
            let bounds = UIScreen.main.bounds
            spinner.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            comic?.onComplete = {
                self.comicImageView.image = self.comic?.image
                self.spinner.stopAnimating()
                self.updateConstraintsForSize(self.viewSizeWithoutInsets())
                self.updateMinZoomScaleForSize(self.viewSizeWithoutInsets())
            }
        }
        scrollView.maximumZoomScale = 3.0
        self.edgesForExtendedLayout = UIRectEdge()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(touchTwice))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        defaults.set(date, forKey: "date")
        updateConstraintsForSize(viewSizeWithoutInsets())
        updateMinZoomScaleForSize(viewSizeWithoutInsets())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraintsForSize(viewSizeWithoutInsets())
        updateMinZoomScaleForSize(viewSizeWithoutInsets())
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        updateConstraintsForSize(viewSizeWithoutInsets())
    }
    
    func touchTwice(_ gesture: UIGestureRecognizer) {
//        if (date.weekday != 1) {
//            self.performSegue(withIdentifier: "ZoomComic", sender: self)
//        } else {
            self.scrollView.setZoomScale(1.5, animated: true)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ZoomComic") {
            guard let vc = segue.destination as? ZoomedComicViewController
                else { return }
            vc.initialize(comic)
        }
    }
    
    
    // MARK: - Update Constraints
    
    fileprivate func viewSizeWithoutInsets() -> CGSize {
        var size = view.bounds.size
        size.height -= UIApplication.shared.statusBarFrame.size.height
        if let navController = self.navigationController {
            size.height -= navController.navigationBar.frame.size.height
        }
        return size
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        let bounds = UIScreen.main.bounds
        spinner.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let yOffset = max(0, (size.height - comicImageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - comicImageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / comicImageView.bounds.width
        let heightScale = size.height / comicImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
}


extension ComicViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(viewSizeWithoutInsets())
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return comicImageView
    }
    
}

