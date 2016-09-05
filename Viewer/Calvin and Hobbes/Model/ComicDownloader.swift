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
//    static let baseURL = "http://localhost:5000"
    
    class func getComic(date: NSDate, completionHandler: (String?, [Int]?,  UIImage?) -> ()) {
        let datePart = date.stringFromFormat("YYYY-MM-dd")
        
        Alamofire.request(.GET, baseURL + "/comic/" + datePart)
        .responseJSON { response in
            if let json = response.result.value as? [String: AnyObject] {
                if let imageUrl = json["url"] as? String, imageSepsString = json["seps"] as? String {
                    let imageSeps = imageSepsString.characters.split(" ")
                                                              .map(String.init)
                                                              .map{ Int($0)! }
                    Alamofire.request(.GET, imageUrl)
                    .responseData { response in
                        print(imageSeps)
                        if let data = response.data {
                            completionHandler(imageUrl, imageSeps, UIImage(data: data))
                        } else {
                            completionHandler(imageUrl, imageSeps, nil)
                        }
                    }
                } else {
                    completionHandler(nil, nil, nil)
                }
            }
        }
    }
    
    class func searchComics(query: String, completionHandler: ([SearchResult]) -> ()) {
        let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        Alamofire.request(.GET, baseURL + "/search/" + escapedQuery)
        .responseJSON { response in
            if let results = response.result.value as? [[String: String]] {
                completionHandler(results.map({ result in
                    return SearchResult(date: result["date"]!, snippet: result["text"]!)
                }))
            }
        }
    }
    
}