//
//  SearchResult.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 4/4/16.
//  Copyright © 2016 Adam Van Prooyen. All rights reserved.
//

import Foundation
import Timepiece

class SearchResult {
    
    let date: Date
    let snippet: String
    
    init(date: Date, snippet: String) {
        self.date = date
        self.snippet = snippet
    }
    
    init(date: String, snippet: String) {
        self.date = date.dateFromFormat("yyyy-MM-dd")!
        self.snippet = snippet
    }
    
}
