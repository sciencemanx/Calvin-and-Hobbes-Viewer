//
//  ComicSearchTableViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 4/3/16.
//  Copyright © 2016 Adam Van Prooyen. All rights reserved.
//

import UIKit
import Timepiece

class ComicSearchViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var comicManager: ComicManager!
    var results: [SearchResult] = []
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowComic") {
            let date = results[tableView.indexPathForSelectedRow!.row].date.dateFromFormat("yyyy-MM-dd")!
            print(date)
            let vc = segue.destinationViewController as! ComicPageViewController
            vc.initialize(comicManager, date: date)
        }
    }
    
    // TODO: Move to its own class
    
    func attributeString(string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        let boldAttrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(15)]
        var isBold = false
        for c in string.characters {
            if (c == "_") {
                isBold = !isBold
            }
            else {
                if (isBold) {
                    let boldString = NSMutableAttributedString(string: String(c), attributes: boldAttrs)
                    attributedString.appendAttributedString(boldString)
                }
                else {
                    let normalString = NSMutableAttributedString(string: String(c))
                    attributedString.appendAttributedString(normalString)
                }
            }
        }
        return attributedString
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
        
        cell.textLabel?.attributedText = attributeString(results[indexPath.row].snippet)
        cell.detailTextLabel?.text = results[indexPath.row].date
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("ShowComic", sender: self)
    }
    
}


extension ComicSearchViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ComicDownloader.searchComics(searchText, completionHandler: { results in
            self.results = results
            self.tableView.reloadData()
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}