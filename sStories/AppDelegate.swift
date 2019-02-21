//
//  AppDelegate.swift
//  sStories
//
//  Created by Nate on 12/7/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        Sound.sharedInstance.setup()
        playSoundClip(.fmishingThrowbackDrop)
        window = UIWindow()
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()

        return true
    }
}

