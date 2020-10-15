//
//  AppDelegate.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var appCoordinator: AppCoordinator!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		setup()
		return true
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		/// Handle login/register call back
		if let code = URLComponents(string: url.absoluteString)?.queryItems?.filter { $0.name == "code" }.first?.value {
			NotificationCenter.default.post(name: .callbackCode, object: nil, userInfo: ["code": code])
		}
		return true
	}
}


extension AppDelegate {
	func setup() {
		self.appCoordinator = AppCoordinator(navigation: UINavigationController())
		appCoordinator.start()
	}
}


