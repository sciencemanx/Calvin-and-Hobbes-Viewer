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
    
    func initialize(_ comic: Comic) {
        self.comic = comic
        panels = comic.panels()
        let vc = storyboard!.instantiateViewController(withIdentifier: "ComicViewController")
            as! ComicViewController
        vc.initialize(Comic(date: Date().change(weekday: 1), image: panels.first!))
        self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
}


extension ZoomedComicViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let oldVC = viewController as! ComicViewController
        let idx = panels.index(of: oldVC.comicImageView.image!)! + 1
        if (idx < panels.count) {
            let vc = storyboard!.instantiateViewController(withIdentifier: "ComicViewController")
                as! ComicViewController
            let image = panels[idx]
            vc.initialize(Comic(date: Date().change(weekday: 1), image: image))
            return vc
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let oldVC = viewController as! ComicViewController
        let idx = panels.index(of: oldVC.comicImageView.image!)! - 1
        if (idx > -1) {
            let vc = storyboard!.instantiateViewController(withIdentifier: "ComicViewController")
                as! ComicViewController
            let image = panels[idx]
            vc.initialize(Comic(date: Date().change(weekday: 1), image: image))
            return vc
        }
        return nil
    }
    
}
