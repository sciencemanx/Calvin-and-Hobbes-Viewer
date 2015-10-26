//
//  ComicViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 10/1/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import UIKit

class ComicViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var comicImageView: UIImageView!
    
    @IBOutlet weak var imageTopPadding: NSLayoutConstraint!
    @IBOutlet weak var imageBottomPadding: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    var comic: Comic!
    var date: NSDate!
    
    init(comic: Comic, date: NSDate) {
        self.comic = comic
        self.date = date
        super.init(nibName: "ComicView", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                self.updateConstraints()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        updateConstraints()
    }
    
    override func viewWillDisappear(animated: Bool) {
        scrollView.zoomScale = 1
    }
    
    func updateConstraints() {
        if let image = comicImageView.image {
            let bounds = comicImageView.bounds
            let width = bounds.size.width
            imageHeight.constant =  width / image.size.width * image.size.height
            scrollView.contentSize = comicImageView.bounds.size
            view.layoutIfNeeded()
        }
        let bounds = UIScreen.mainScreen().bounds
        spinner.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        updateConstraints()
    }
    
}

extension ComicViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
//        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return comicImageView
    }
    
}

