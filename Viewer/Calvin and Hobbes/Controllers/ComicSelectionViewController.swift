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

class ComicSelectionViewController: PDTSimpleCalendarViewController, PDTSimpleCalendarViewDelegate {
    
    let comicManager = ComicManager()
    let defaults = NSUserDefaults.standardUserDefaults()
    var userSelection = true // changing selectedDate programmatically calls didSelectDate which
                             // trigger an unwanted transition
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        firstDate = comicManager.startDate
        lastDate = comicManager.endDate
        if let date = defaults.objectForKey("date") as? NSDate {
            userSelection = false
            selectedDate = date
            scrollToSelectedDate(true)
        }
    }
    
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, didSelectDate date: NSDate!) {
        if (userSelection) {
            defaults.setObject(date, forKey: "date")
            
            let destination = ComicPageViewController(comicManager: comicManager, date: date)
            navigationController?.showViewController(destination, sender: self)
        }
        userSelection = true
    }
    
}
