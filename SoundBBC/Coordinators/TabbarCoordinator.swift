//
//  TabbarCoordinator.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit


class TabbarCoordinator: BaseCoordinator {
	
	override func start() {
		// Listen
		let listenNavigationController = UINavigationController()
		listenNavigationController.tabBarItem = UITabBarItem(title: "Listen", image: nil, tag: 0)
		let listenCoordinator = ListenCoordinator(navigation: listenNavigationController)
		
		// My Sound
		let mySoundNavigationController = UINavigationController()
		mySoundNavigationController.tabBarItem = UITabBarItem(title: "My Sound", image: nil, tag: 1)
		let mySoundCoordinator = MySoundCoordinator(navigation: mySoundNavigationController)
		
		// Search
		let searchNavigationController = UINavigationController()
		searchNavigationController.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 2)
		let searchCoordinator = SearchCoordinator(navigation: searchNavigationController)
		
		let tabbarViewController = TabbarController()
		tabbarViewController.viewControllers = [listenNavigationController,
												mySoundNavigationController,
												searchNavigationController]
		self.navigationController.viewControllers = [tabbarViewController]
		
		start(coordinator: listenCoordinator)
		start(coordinator: mySoundCoordinator)
		start(coordinator: searchCoordinator)
	}
}
