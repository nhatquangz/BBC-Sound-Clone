//
//  StatusBarStyleNavigationController.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/8/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit


class StatusBarStyleNavigationController: UINavigationController {
	/// Change status bar style depending on playing view's position
	override var preferredStatusBarStyle: UIStatusBarStyle {
		let playingPosition = PlayingViewModel.shared.position.value
		return playingPosition == .full ? .lightContent : .default
	}
}
