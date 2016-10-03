//
//  ComicSearchTableViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 4/3/16.
//  Copyright © 2016 Adam Van Prooyen. All rights reserved.
//

import UIKit
import Timepiece

class ComicSearchViewController: UIViewController {

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
    
}

extension ComicSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
