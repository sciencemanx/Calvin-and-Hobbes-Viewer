//
//  FavoritesViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 4/14/16.
//  Copyright © 2016 Adam Van Prooyen. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    let defaults = UserDefaults.standard
    var favorites: [Date]!
    var comicManager: ComicManager!
    
    @IBOutlet weak var tableView: UITableView!
    
    func initialize(_ comicManager: ComicManager) {
        self.comicManager = comicManager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let favorites = defaults.object(forKey: "favorites") as? [Date] {
            self.favorites = favorites.sorted(by: { $0.compare($1) == .orderedAscending })
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowComic") {
            let date = favorites[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
            let vc = segue.destination as! ComicPageViewController
            vc.initialize(comicManager, date: date)
        }
    }

}

extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Favorite", for: indexPath)
        
        cell.textLabel?.text = favorites[(indexPath as NSIndexPath).row].stringFromFormat("EEEE d MMMM YYYY")
        
        return cell
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowComic", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
