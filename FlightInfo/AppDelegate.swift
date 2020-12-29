//
//  AppDelegate.swift
//  FlightInfo
//
//  Created by Cong Le on 12/28/20.
//

import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var navigationController: UINavigationController?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // Set up style
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.backgroundColor = .systemBackground
    
    // Setup the view controllers
    let mainVC = ViewController()
    navigationController = UINavigationController(rootViewController: mainVC)
    navigationController?.navigationBar.barTintColor = .black
    window?.rootViewController = navigationController
    return true
  }
}

