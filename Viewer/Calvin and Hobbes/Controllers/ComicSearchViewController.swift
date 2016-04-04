//
//  ComicSearchTableViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 4/3/16.
//  Copyright © 2016 Adam Van Prooyen. All rights reserved.
//

import UIKit

class ComicSearchViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var results: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ComicSearchViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResult", forIndexPath: indexPath)
        
        cell.textLabel?.text = results[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

extension ComicSearchViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ComicDownloader.searchComics(searchText, completionHandler: { results in
            self.results = results
            self.tableView.reloadData()
        })
    }
    
}