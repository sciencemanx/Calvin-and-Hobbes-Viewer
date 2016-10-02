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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowComic") {
            let date = results[(tableView.indexPathForSelectedRow! as NSIndexPath).row].date
            let vc = segue.destination as! ComicPageViewController
            vc.initialize(comicManager, date: date)
        }
    }
    
    // TODO: Move to its own class
    
    func attributeString(_ string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        let boldAttrs = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)]
        var isBold = false
        for c in string.characters {
            if (c == "_") {
                isBold = !isBold
            }
            else {
                if (isBold) {
                    let boldString = NSMutableAttributedString(string: String(c), attributes: boldAttrs)
                    attributedString.append(boldString)
                }
                else {
                    let normalString = NSMutableAttributedString(string: String(c))
                    attributedString.append(normalString)
                }
            }
        }
        return attributedString
    }

}


extension ComicSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResult", for: indexPath)
        
        cell.textLabel?.attributedText = attributeString(results[(indexPath as NSIndexPath).row].snippet)
        cell.detailTextLabel?.text = results[(indexPath as NSIndexPath).row].date.stringFromFormat("EEEE d MMMM YYYY")
        
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowComic", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension ComicSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ComicDownloader.searchComics(searchText, completionHandler: { results in
            self.results = results
            self.tableView.reloadData()
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
