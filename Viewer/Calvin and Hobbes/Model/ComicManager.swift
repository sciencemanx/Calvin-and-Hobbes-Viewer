//
//  ComicManager.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 10/1/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import Foundation
import Timepiece

class ComicManager {
    
    private let startDate = NSDate.date(year: 1985, month: 11, day: 18)
    private let endDate = NSDate.date(year: 1995, month: 12, day: 31)
    
    private var comics = [NSDate: Comic]()
    private let downloader = ComicDownloader()
    
    private func dateForSection(num: Int) -> NSDate {
        return (startDate + num.months).beginningOfMonth
    }
    
    func numberOfSections() -> Int {
        return ((endDate.year * 12 + endDate.month) - (startDate.year * 12 + startDate.month)) + 1
    }
    
    func numberOfComicsForSection(num: Int) -> Int {
        let beginningOfMonth = dateForSection(num).beginningOfMonth
        let endOfMonth = dateForSection(num).endOfMonth
        
        if (num == 0) { return endOfMonth.day - startDate.day + 1 }
        else { return endOfMonth.day - beginningOfMonth.day + 1 }
    }
    
    func headerForSection(num: Int) -> String {
        let sectionDate = dateForSection(num)
        return sectionDate.stringFromFormat("MMMM YYYY")
    }
    
    func comicForSection(section: Int, row: Int) -> Comic {
        var dateForComic: NSDate
        if (section == 0) {
            dateForComic = startDate + row.days
        } else {
            dateForComic = dateForSection(section) + row.days
        }
        if let comic = comics[dateForComic] {
            return comic
        } else {
            let comic = Comic(date: dateForComic)
            comics[dateForComic] = comic
            return comic
        }
    }
    
}