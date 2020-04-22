//
//  MySoundCoordinator.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit


class MySoundCoordinator: BaseCoordinator {
	
	override func start() {
		let mySoundVC = MySoundViewController()
		self.navigationController.viewControllers = [mySoundVC]
	}
	
}
