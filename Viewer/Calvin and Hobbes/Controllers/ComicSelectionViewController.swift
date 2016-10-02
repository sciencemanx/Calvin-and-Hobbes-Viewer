//
//  ComicSelectionViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 10/1/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import UIKit
import Timepiece
import PDTSimpleCalendar

class ComicSelectionViewController: PDTSimpleCalendarViewController {
    
    let comicManager = ComicManager()
    let defaults = UserDefaults.standard
    let orange = UIColor(red: 255/255, green: 116/255, blue: 0, alpha: 1)
    var userSelection = true // changing selectedDate programmatically calls didSelectDate which
                             // triggers an unwanted transition
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        firstDate = comicManager.startDate
        lastDate = comicManager.endDate
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.navigationController?.navigationBar.tintColor = orange
        
        if (defaults.object(forKey: "favorites") == nil) {
            defaults.set([Date](), forKey: "favorites")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let date = self.defaults.object(forKey: "date") as? Date {
            self.userSelection = false
            self.selectedDate = date
            self.scroll(toSelectedDate: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "ShowComic":
            let vc = segue.destination as! ComicPageViewController
            let date = defaults.object(forKey: "date") as! Date
            vc.initialize(comicManager, date: date)
            break
        case "SearchComics":
            let vc = segue.destination as! ComicSearchViewController
            vc.comicManager = comicManager
            break
        case "FavoriteComics":
            let vc = segue.destination as! FavoritesViewController
            vc.initialize(comicManager)
            break
        default:
            break
        }
    }
    
}


extension ComicSelectionViewController: PDTSimpleCalendarViewDelegate {
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelect date: Date!) {
        if (userSelection) {
            defaults.set(date, forKey: "date")
            
            self.performSegue(withIdentifier: "ShowComic", sender: self)
        }
        userSelection = true
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, circleColorFor date: Date!) -> UIColor! {
        return .orange
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, shouldUseCustomColorsFor date: Date!) -> Bool {
        if let favorites = defaults.object(forKey: "favorites") as? [Date] {
            if (favorites.contains(date)) {
                return true
            }
        }
        return false
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, textColorFor date: Date!) -> UIColor! {
        if let favorites = defaults.object(forKey: "favorites") as? [Date] {
            if (favorites.contains(date)) {
                return .white
            }
        }
        return .black
    }
    
}
