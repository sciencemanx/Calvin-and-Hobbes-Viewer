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
    
    static let baseURL = "https://calvinserver.herokuapp.com"
    
    class func getComic(date: NSDate, completionHandler: (String?, UIImage?) -> ()) {
        let datePart = date.stringFromFormat("YYYY-MM-dd")
        
        Alamofire.request(.GET, baseURL + "/comic/" + datePart)
        .responseJSON { response in
            if let json = response.result.value as? [String: AnyObject] {
                if let imageUrl = json["url"] as? String {
                    Alamofire.request(.GET, imageUrl)
                    .responseData { response in
                        if let data = response.data {
                            completionHandler(imageUrl, UIImage(data: data))
                        } else {
                            completionHandler(imageUrl, nil)
                        }
                    }
                } else {
                    completionHandler(nil, nil)
                }
            }
        }
    }
    
    class func searchComics(query: String, completionHandler: ([String]) -> ()) {
        let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        Alamofire.request(.GET, baseURL + "/search/" + escapedQuery)
        .responseJSON { response in
            if let results = response.result.value as? [String] {
                completionHandler(results)
            }
        }
    }
    
}