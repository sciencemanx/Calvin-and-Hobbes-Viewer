//
//  ComicViewController.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 10/1/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import UIKit

class ComicViewController: UIViewController {
    
    @IBOutlet weak var comicScrollView: UIScrollView!
    @IBOutlet weak var comicImage: UIImageView!
    
    var date = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

