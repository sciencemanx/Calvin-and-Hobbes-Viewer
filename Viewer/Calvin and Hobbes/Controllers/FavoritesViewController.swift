//
//  FavoritesViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 4/14/16.
//  Copyright © 2016 Adam Van Prooyen. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate {

    let defaults = NSUserDefaults.standardUserDefaults()
    var favorites: [NSDate]!
    var comicManager: ComicManager!
    
    @IBOutlet weak var tableView: UITableView!
    
    func initialize(comicManager: ComicManager) {
        self.comicManager = comicManager
    }
    
    override func viewWillAppear(animated: Bool) {
        if let favorites = defaults.objectForKey("favorites") as? [NSDate] {
            self.favorites = favorites.sort({ $0.compare($1) == .OrderedAscending })
        }
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowComic") {
            let date = favorites[tableView.indexPathForSelectedRow!.row]
            let vc = segue.destinationViewController as! ComicPageViewController
            vc.initialize(comicManager, date: date)
        }
    }

}

extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Favorite", forIndexPath: indexPath)
        
        cell.textLabel?.text = favorites[indexPath.row].stringFromFormat("EEEE d MMMM YYYY")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowComic", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
