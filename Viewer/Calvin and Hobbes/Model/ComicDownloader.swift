//
//  ComicDownloader.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 10/1/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import Foundation
import Alamofire
import Timepiece

class ComicDownloader {
    
    class func getComic(date: NSDate, done: (String?, UIImage?) -> ()) {
        let datePart = date.stringFromFormat("YYYY-MM-dd")
        
        Alamofire.request(.GET, "https://calvinserver.herokuapp.com/comic/" + datePart)
        .responseJSON { response in
            if let json = response.result.value as? [String: AnyObject] {
                if let imageUrl = json["url"] as? String {
                    Alamofire.request(.GET, imageUrl)
                    .responseData { response in
                        if let data = response.data {
                            done(imageUrl, UIImage(data: data))
                        } else {
                            done(imageUrl, nil)
                        }
                    }
                } else {
                    done(nil, nil)
                }
            }
        }
    }
    
}