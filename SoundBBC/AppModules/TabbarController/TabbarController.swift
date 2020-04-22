//
//  TabbarViewController.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit


class TabbarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
}

// MARK: - Setup
extension TabbarController {
	func setup() {
		self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: AppDefinition.Font.reithSans.size(12)], for: .normal)
	}
}

