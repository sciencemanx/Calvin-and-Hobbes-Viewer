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
    var panelSeparators: [Int]?
    
    // Lets you register completion handler for comic download after initialization
    var onComplete: () -> () = {}
    
    init(date: NSDate) {
        self.date = date
        ComicDownloader.getComic(date, completionHandler: {
            self.url = $0
            self.panelSeparators = $1
            self.image = $2
            self.onComplete()
        })
    }
    
    init(date: NSDate, image: UIImage) {
        self.date = date
        self.image = image
    }
    
    func panels() -> [UIImage]? {
        if let image = self.image, seps = self.panelSeparators {
            let cgImage = image.CGImage!
            var panels: [UIImage] = []
            for (start, end) in zip([0] + seps, seps + [Int(image.size.width)]) {
                let panel = CGImageCreateWithImageInRect(cgImage, CGRect(x: start, y: 0, width: end - start, height: Int(image.size.height)))
                panels.append(UIImage(CGImage: panel!))
            }
            return panels
        }
        return nil
    }
    
}