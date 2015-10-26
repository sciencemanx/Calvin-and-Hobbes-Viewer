//
//  Comic.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 10/1/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import Foundation
import UIKit

class Comic {
    
    let date: NSDate
    var image: UIImage?
    var url: String?
    
    var onComplete: () -> () = {}
    
    init(date: NSDate) {
        self.date = date
        ComicDownloader.getComic(date, done: {
            self.url = $0
            self.image = $1
            self.onComplete()
        })
    }
    
}