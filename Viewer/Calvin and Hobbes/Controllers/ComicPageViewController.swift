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
    var date: Date!
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    init(comicManager: ComicManager, date: Date) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        initialize(comicManager, date: date)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitleForDate(date)
        updateFavoriteButton()
    }
    
    func initialize(_ comicManager: ComicManager, date: Date) {
        self.comicManager = comicManager
        
        self.delegate = self
        self.dataSource = self
        
        self.date = date
        
        let vc = viewControllerForDate(date)
        setViewControllers([vc!], direction: .forward, animated: true, completion: nil)
    }
    
    func logComicView(_ date: Date) {
        
    }
    
    func updateFavoriteButton() {
        if let favorites = defaults.object(forKey: "favorites") as? [Date] {
            if (favorites.contains(date)) {
                favoriteButton.title = "Saved"
            } else {
                favoriteButton.title = "Save"
            }
        }
    }
    
    @IBAction func toggleFavorite(_ sender: UIBarButtonItem) {
        if var favorites = defaults.object(forKey: "favorites") as? [Date] {
            if (favorites.contains(date)) {
                favorites.remove(at: favorites.index(of: date)!)
            } else {
                favorites.append(date)
            }
            defaults.set(favorites, forKey: "favorites")
        }
        updateFavoriteButton()
    }
    
    func viewControllerForDate(_ date: Date) -> ComicViewController? {
        if (date < comicManager.startDate || date > comicManager.endDate) {
            return nil
        } else {
            let comic = comicManager.comicForDate(date)
            if let comicVC = storyboard?.instantiateViewController(withIdentifier: "ComicViewController")
                as? ComicViewController {
                comicVC.initialize(comic)
                return comicVC
            }
            return nil
        }
    }
    
    func setTitleForDate(_ date: Date) {
        self.title = date.stringFromFormat("EEEE d MMMM YYYY")
    }
    
}

extension ComicPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let comicViewController = viewController as! ComicViewController
        return viewControllerForDate((comicViewController.date! as Date) + 1.day)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let comicViewController = viewController as! ComicViewController
        return viewControllerForDate((comicViewController.date! as Date) - 1.day)
    }
    
    @objc(pageViewController:willTransitionToViewControllers:) func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        nextVC = pendingViewControllers.first as? ComicViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed) {
            if let vc = nextVC {
                date = vc.date as Date!
                setTitleForDate(vc.date as Date)
                updateFavoriteButton()
            }
        }
    }
    
}
