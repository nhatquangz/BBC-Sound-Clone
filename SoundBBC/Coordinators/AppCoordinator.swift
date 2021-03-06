//
//  AppCoordinator.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit


class AppCoordinator: BaseCoordinator {
	
	var window = UIWindow(frame: UIScreen.main.bounds)
	
	override func start() {
		self.navigationController.isNavigationBarHidden = true
		self.window.rootViewController = self.navigationController
		self.window.makeKeyAndVisible()
		
		let splashViewController = SplashViewController()
		splashViewController.cooridinator = self
		self.navigationController.viewControllers = [splashViewController]
	}
}

// MARK: - Navigation
extension AppCoordinator {
	func tabbar() {
		let tabCooridinator = TabbarCoordinator(navigation: self.navigationController)
		start(coordinator: tabCooridinator)
	}
	
	func login() {
		let loginCoordinator = LoginCoordinator(navigation: self.navigationController)
		start(coordinator: loginCoordinator)
	}
}

