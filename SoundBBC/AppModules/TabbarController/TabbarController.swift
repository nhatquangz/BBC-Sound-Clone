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
	
	private let playingViewController = PlayingViewController.shared

	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		addPlayingView()
	}
}

// MARK: - Setup
extension TabbarController {
	func setup() {
		self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: AppDefinition.Font.reithSans.size(12)], for: .normal)
		self.tabBar.tintColor = AppDefinition.Color.main
	}
}

// MARK: - Playing View Controller
extension TabbarController {
	func addPlayingView() {
		let playingView: UIView = playingViewController.view
		view.addSubview(playingView)
		view.bringSubviewToFront(self.tabBar)
		addChild(playingViewController)
		playingViewController.didMove(toParent: self)
		
		playingView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			playingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			playingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			playingView.heightAnchor.constraint(equalTo: view.heightAnchor),
			playingView.topAnchor.constraint(equalTo: view.topAnchor)
		])
		
		let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(recognizer:)))
		playingView.addGestureRecognizer(pan)
	}
}

// MARK: - Playing State
extension TabbarController {
	enum PlayingViewState {
		case full, mini, hide
	}
	
	func changePlayingViewState(_ state: PlayingViewState) {
		var topConstant: CGFloat
		let fullHeight = self.view.frame.height
		let tabbarHeight = self.tabBar.frame.height
		let miniBarHeight = AppDefinition.Dimension.playingBarHeight
		
		switch state {
		case .full:
			topConstant = 0
		case .mini:
			topConstant = fullHeight - tabbarHeight - miniBarHeight
		case .hide:
			topConstant = fullHeight - tabbarHeight
		}
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
			self.view.layoutIfNeeded()
			self.playingViewController.view.frame.origin.y = topConstant
		}, completion: nil)
	}
	
	@objc func handlePan(recognizer: UIPanGestureRecognizer) {
		let translation = recognizer.translation(in: self.view)
		guard let playingView = recognizer.view else { return }
		
		// Max distance that playing view can move down from the full state
		let maxDistance = self.tabBar.frame.origin.y + AppDefinition.Dimension.playingBarHeight
		
		let newY = playingView.frame.origin.y + translation.y
		if newY <= maxDistance && newY >= 0 {
			playingView.frame.origin.y = newY
			self.showTabbar(percentage: newY / maxDistance)
		}
		recognizer.setTranslation(CGPoint.zero, in: self.view)
		
		if recognizer.state == .ended {
			let yVelocity = recognizer.velocity(in: self.view).y
			if yVelocity <= 0 {
				self.changePlayingViewState(.full)
				self.showTabbar(percentage: 0, animation: true)
			} else {
				self.changePlayingViewState(.mini)
				self.showTabbar(percentage: 1, animation: true)
			}
		}
	}
	
	
	private func showTabbar(percentage: CGFloat, animation: Bool = false) {
		let d = self.tabBar.frame.height * (1 - percentage)
		let originY = self.view.frame.height - self.tabBar.frame.height
		let newY = originY + d
		if animation {
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
				self.view.layoutIfNeeded()
				self.tabBar.frame.origin.y = newY
			}, completion: nil)
		} else {
			self.tabBar.frame.origin.y = newY
		}
	}
}

