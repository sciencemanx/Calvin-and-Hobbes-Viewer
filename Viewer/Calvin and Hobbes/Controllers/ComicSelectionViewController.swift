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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.firstDate = comicManager.startDate
        self.lastDate = comicManager.endDate
    }
    
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, didSelectDate date: NSDate!) {
        let destination = ComicViewController()
        destination.comic = comicManager.comicForDate(date)
        self.navigationController?.showViewController(destination, sender: self)
    }
    
}
