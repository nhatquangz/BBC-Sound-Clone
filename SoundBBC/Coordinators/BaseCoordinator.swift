//
//  BaseCoordinator.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit


protocol Coordinator: AnyObject {
	var navigationController: UINavigationController { get set }
	var childCoordinators: [Coordinator] { get set }
	var parentCoordinator: Coordinator? { get set }
	
	func start()
	func start(coordinator: Coordinator)
	func didFinish(coordinator: Coordinator)
}


class BaseCoordinator: Coordinator {
	
	var navigationController: UINavigationController
	var childCoordinators: [Coordinator] = []
	var parentCoordinator: Coordinator?
	
	init(navigation: UINavigationController) {
		self.navigationController = navigation
	}
	
	func start() {
		fatalError("Start method must be implemented")
	}
	
	func start(coordinator: Coordinator) {
		self.childCoordinators.append(coordinator)
		coordinator.parentCoordinator = self
		coordinator.start()
	}
	
	func didFinish(coordinator: Coordinator) {
		if let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) {
            self.childCoordinators.remove(at: index)
        }
	}
	
}
