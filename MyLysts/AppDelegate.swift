//
//  AppDelegate.swift
//  MyLysts
//
//  Created by keith martin on 6/21/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        GIDSignIn.sharedInstance().clientID = "1080273992297-bl7rgf3chvqjsilm9b1eudkmgbt0gleb.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "1080273992297-m2n0djmmru3hr3q3b209cj86ti46cge2.apps.googleusercontent.com"
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            window?.makeKeyAndVisible()
            //let defaults = UserDefaults.standard
            //User.currentUser = User(dictionary: ["username": defaults.string(forKey: DefaultsKeys.username)!])
            let rootViewController = UINavigationController(rootViewController: PageViewController())
            rootViewController.view.backgroundColor = Color.white
            window?.rootViewController = rootViewController
        } else {
            let loginViewController = LoginViewController()
            let rootViewController = UINavigationController(rootViewController: loginViewController)
            rootViewController.view.backgroundColor = Color.white
            window?.makeKeyAndVisible()
            window?.rootViewController = rootViewController
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    


}

