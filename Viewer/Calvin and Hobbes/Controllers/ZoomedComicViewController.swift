//
//  ZoomedComicViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 4/14/16.
//  Copyright © 2016 Adam Van Prooyen. All rights reserved.
//

import UIKit
import Timepiece

class ZoomedComicViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    var comic: Comic!
    var panels: [UIImage]!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        self.dataSource = self
    }
    
    func initialize(comic: Comic) {
        self.comic = comic
        panels = comic.panels()
        let vc = storyboard!.instantiateViewControllerWithIdentifier("ComicViewController")
            as! ComicViewController
        vc.initialize(Comic(date: NSDate().change(weekday: 1), image: panels.first!))
        self.setViewControllers([vc], direction: .Forward, animated: true, completion: nil)
    }
    
}


extension ZoomedComicViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let oldVC = viewController as! ComicViewController
        let idx = panels.indexOf(oldVC.comicImageView.image!)! + 1
        if (idx < panels.count) {
            let vc = storyboard!.instantiateViewControllerWithIdentifier("ComicViewController")
                as! ComicViewController
            let image = panels[idx]
            vc.initialize(Comic(date: NSDate().change(weekday: 1), image: image))
            return vc
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let oldVC = viewController as! ComicViewController
        let idx = panels.indexOf(oldVC.comicImageView.image!)! - 1
        if (idx > -1) {
            let vc = storyboard!.instantiateViewControllerWithIdentifier("ComicViewController")
                as! ComicViewController
            let image = panels[idx]
            vc.initialize(Comic(date: NSDate().change(weekday: 1), image: image))
            return vc
        }
        return nil
    }
    
}