//
//  ListenCoordinator.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit


class ListenCoordinator: BaseCoordinator {
	
	override func start() {
		let listenVC = ListenViewController()
		self.navigationController.viewControllers = [listenVC]
	}
	
}
