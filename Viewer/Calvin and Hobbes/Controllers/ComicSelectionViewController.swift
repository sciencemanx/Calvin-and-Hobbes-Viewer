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
    let defaults = NSUserDefaults.standardUserDefaults()
    var userSelection = true // changing selectedDate programmatically calls didSelectDate which
                             // triggers an unwanted transition
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        firstDate = comicManager.startDate
        lastDate = comicManager.endDate
        if let date = defaults.objectForKey("date") as? NSDate {
            userSelection = false
            selectedDate = date
            scrollToSelectedDate(false)
        }
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.tintColor = .orangeColor()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowComic") {
            let vc = segue.destinationViewController as! ComicPageViewController
            let date = defaults.objectForKey("date") as! NSDate
            vc.initialize(comicManager, date: date)
        }
        if (segue.identifier == "SearchComics") {
            let vc = segue.destinationViewController as! ComicSearchViewController
            vc.comicManager = comicManager
            let date = NSDate()
            date.day
        }
    }
    
}


extension ComicSelectionViewController: PDTSimpleCalendarViewDelegate {
    
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, didSelectDate date: NSDate!) {
        if (userSelection) {
            defaults.setObject(date, forKey: "date")
            
            self.performSegueWithIdentifier("ShowComic", sender: self)
        }
        userSelection = true
    }
    
}
