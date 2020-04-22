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
		self.navigationController.navigationBar.isHidden = true
		self.window.rootViewController = self.navigationController
		self.window.makeKeyAndVisible()
		
		let coordinator = TabbarCoordinator(navigation: navigationController)
		self.start(coordinator: coordinator)
	}
	
}
