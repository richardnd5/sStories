//
//  AppDelegate.swift
//  sStories
//
//  Created by Nate on 12/7/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//
import UIKit
import AudioKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    weak var delegate : SceneDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        Sound.sharedInstance.setup()
        playSoundClip(.fishingThrowbackDrop)
        workingIAPProduct.shared.setupIAP()
        window = UIWindow()
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    

        return true
    }
}

