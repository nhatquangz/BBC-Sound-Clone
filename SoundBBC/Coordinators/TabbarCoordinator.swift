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
		let listenNavigationController = StatusBarStyleNavigationController()
		listenNavigationController.tabBarItem = UITabBarItem(title: "Listen", image: UIImage(named: "listen")?.withRenderingMode(.alwaysTemplate), tag: 0)
		let listenCoordinator = ListenCoordinator(navigation: listenNavigationController)
		
		// My Sound
		let mySoundNavigationController = StatusBarStyleNavigationController()
		mySoundNavigationController.tabBarItem = UITabBarItem(title: "My Sounds", image: UIImage(named: "mysound")?.withRenderingMode(.alwaysTemplate), tag: 1)
		let mySoundCoordinator = MySoundCoordinator(navigation: mySoundNavigationController)
		
		// Search
		let searchNavigationController = StatusBarStyleNavigationController()
		searchNavigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate), tag: 2)
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
