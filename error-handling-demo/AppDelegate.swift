//
//  AppDelegate.swift
//  error-handling-demo
//
//  Created by Sinan Eren on 4/16/18.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ShowUserInfoViewController()
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        return true
    }
}
