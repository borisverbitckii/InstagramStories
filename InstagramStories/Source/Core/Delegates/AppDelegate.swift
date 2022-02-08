//
//  AppDelegate.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIResponder
import UIKit.UIApplication
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
