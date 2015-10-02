//
//  ComicCellView.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 10/1/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import UIKit
import Timepiece

class ComicCellView: UICollectionViewCell {
    @IBOutlet weak var comicThumbnail: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var _date = NSDate()
    
    var date: NSDate {
        get {
            return _date
        }
        set(newDate) {
            _date = newDate
            dateLabel.text = _date.stringFromFormat("dd MMMM YYYY")
        }
    }
    
}
