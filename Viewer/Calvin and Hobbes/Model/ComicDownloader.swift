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
    
    class func getComic(_ date: Date, completionHandler: @escaping (String?, [Int]?,  UIImage?) -> ()) {
        let datePart = date.stringFromFormat("YYYY-MM-dd")
        
        
        Alamofire.request(baseURL + "/comic/" + datePart, method: .get)
        .responseJSON { response in
            if let json = response.result.value as? [String: AnyObject] {
                if let imageUrl = json["url"] as? String, let imageSepsString = json["seps"] as? String {
                    let imageSeps = imageSepsString.components(separatedBy: " ")
                                                   .map{ Int($0)! }
                    Alamofire.request(imageUrl, method: .get)
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
    
    class func searchComics(_ query: String, completionHandler: @escaping ([SearchResult]) -> ()) {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        Alamofire.request(baseURL + "/search/" + escapedQuery, method: .get)
        .responseJSON { response in
            if let results = response.result.value as? [[String: String]] {
                completionHandler(results.map({ result in
                    return SearchResult(date: result["date"]!, snippet: result["text"]!)
                }))
            }
        }
    }
    
}
