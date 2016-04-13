//
//  ComicPageViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 10/25/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import UIKit
import Timepiece

class ComicPageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    var comicManager: ComicManager!
    var nextVC: ComicViewController?
    var date: NSDate!
    
    init(comicManager: ComicManager, date: NSDate) {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        initialize(comicManager, date: date)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initialize(comicManager: ComicManager, date: NSDate) {
        self.comicManager = comicManager
        
        self.delegate = self
        self.dataSource = self
        
        self.setTitleForDate(date)
        
        let vc = viewControllerForDate(date)
        setViewControllers([vc!], direction: .Forward, animated: true, completion: nil)
    }
    
    func viewControllerForDate(date: NSDate) -> ComicViewController? {
        if (date < comicManager.startDate || date > comicManager.endDate) {
            return nil
        } else {
            let comic = comicManager.comicForDate(date)
            if let comicVC = storyboard?.instantiateViewControllerWithIdentifier("ComicViewController")
                as? ComicViewController {
                comicVC.initialize(comic, date)
                return comicVC
            }
            return nil
        }
    }
    
    func setTitleForDate(date: NSDate) {
        self.title = date.stringFromFormat("EEEE d MMMM YYYY")
    }
    
}

extension ComicPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let comicViewController = viewController as! ComicViewController
        return viewControllerForDate(comicViewController.date! + 1.day)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let comicViewController = viewController as! ComicViewController
        return viewControllerForDate(comicViewController.date! - 1.day)
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        nextVC = pendingViewControllers.first as? ComicViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed) {
            if let vc = nextVC {
                setTitleForDate(vc.date)
            }
        }
    }
    
}
