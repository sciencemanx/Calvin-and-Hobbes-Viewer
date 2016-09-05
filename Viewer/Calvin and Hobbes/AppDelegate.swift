//
//  AppDelegate.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 9/27/15.
//  Copyright © 2015 Adam Van Prooyen. All rights reserved.
//

import UIKit
import Fabric
import Answers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Answers.self])
        return true
    }

}

