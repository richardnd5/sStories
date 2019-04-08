//
//  AppDelegate.swift
//  sStories
//
//  Created by Nate on 12/7/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//
import UIKit
import AudioKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

//var navController: UINavigationController?


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    weak var delegate : SceneDelegate?
    
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
    
        Sound.shared.setup()
        playSoundClip(.openingNoodle)
        workingIAPProduct.shared.setupIAP()
        window = UIWindow()
//        window?.rootViewController = TempletonViewController()
        window?.rootViewController = BookshelfViewController()
        window?.makeKeyAndVisible()
    

        return true
    }
    
    
}

