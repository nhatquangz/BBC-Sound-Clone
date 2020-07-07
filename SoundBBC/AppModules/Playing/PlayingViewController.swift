//
//  PlayingViewController.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/7/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit

class PlayingViewController: UIViewController {
	
	static let shared = PlayingViewController()
	
	enum State {
		case full, mini, hide
	}
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
}



// MARK: - Init function
extension PlayingViewController {
	func setup() {
		self.view.backgroundColor = .random
	}
}

