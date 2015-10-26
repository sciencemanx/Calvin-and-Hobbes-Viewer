//
//  AppDelegate.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 9/27/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = .whiteColor()
        
        let picker = ComicSelectionViewController()
        let navController = UINavigationController.init(rootViewController: picker)
        
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

