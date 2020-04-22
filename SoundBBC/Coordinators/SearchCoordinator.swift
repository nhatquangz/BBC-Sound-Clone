//
//  SearchCoordinator.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit


class SearchCoordinator: BaseCoordinator {
	
	override func start() {
		let searchVC = UIViewController()
		self.navigationController.viewControllers = [searchVC]
	}
	
}
