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
    
    init(comicManager: ComicManager, date: NSDate) {
        self.comicManager = comicManager
        
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        self.delegate = self
        self.dataSource = self
        
        self.setTitleForDate(date)
        
        let vc = viewControllerForDate(date)
        setViewControllers([vc!], direction: .Forward, animated: true, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewControllerForDate(date: NSDate) -> ComicViewController? {
        if (date < comicManager.startDate || date > comicManager.endDate) {
            return nil
        } else {
            let comic = comicManager.comicForDate(date)
            return ComicViewController(comic: comic, date: date)
        }
    }
    
    func setTitleForDate(date: NSDate) {
        self.title = date.stringFromFormat("EEEE dd MMMM YYYY")
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
