//
//  TabbarViewController.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift


class TabbarController: UITabBarController {
	
	private let playingView = PlayingView()
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
}

// MARK: - Setup
extension TabbarController {
	func setup() {
		self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: AppConstants.Font.reithSans.size(12)], for: .normal)
		self.tabBar.tintColor = AppConstants.Color.main
		addPlayingView()
		
		/// Handle request changing playingview's position
		PlayingViewModel.shared.changePosition.asObservable()
			.distinctUntilChanged()
			.subscribe(onNext: { [weak self] position in
				self?.changePlayingViewState(position)
			})
		.disposed(by: disposeBag)
	}
}

// MARK: - Playing View Controller
extension TabbarController {
	func addPlayingView() {
		view.addSubview(playingView)
		view.bringSubviewToFront(self.tabBar)
		playingView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			playingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			playingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			playingView.heightAnchor.constraint(equalTo: view.heightAnchor),
			playingView.topAnchor.constraint(equalTo: view.bottomAnchor)
		])
		let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(recognizer:)))
		playingView.addGestureRecognizer(pan)
	}
}

// MARK: - Playing State
extension TabbarController {
	private func changePlayingViewState(_ state: PlayingViewPosition) {
		var topConstant: CGFloat
		let fullHeight = self.view.frame.height
		let tabbarHeight = self.tabBar.frame.height
		let miniBarHeight = AppConstants.Dimension.playingBarHeight
		
		switch state {
		case .full:
			topConstant = 0
		case .mini:
			topConstant = fullHeight - tabbarHeight - miniBarHeight
		case .hide:
			topConstant = fullHeight - tabbarHeight
		}
		PlayingViewModel.shared.position.accept(state)
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
			self.view.layoutIfNeeded()
			self.playingView.frame.origin.y = topConstant
			self.setNeedsStatusBarAppearanceUpdate()
		})
	}
	
	@objc func handlePan(recognizer: UIPanGestureRecognizer) {
		let translation = recognizer.translation(in: self.view)
		guard let playingView = recognizer.view else { return }
		
		// Max distance that playing view can move down from the full state
		let maxDistance = self.tabBar.frame.origin.y - AppConstants.Dimension.playingBarHeight
		
		let newY = playingView.frame.origin.y + translation.y
		if newY <= maxDistance && newY >= 0 {
			playingView.frame.origin.y = newY
			self.showTabbar(percentage: newY / maxDistance)
			self.showSmallPlayBar(percentage: 1 - ((maxDistance - newY) / 50))
		}
		recognizer.setTranslation(CGPoint.zero, in: self.view)
		
		if recognizer.state == .ended {
			let yVelocity = recognizer.velocity(in: self.view).y
			if yVelocity <= 0 {
				self.changePlayingViewState(.full)
				self.showTabbar(percentage: 0, animation: true)
				self.showSmallPlayBar(percentage: 0)
			} else {
				self.changePlayingViewState(.mini)
				self.showTabbar(percentage: 1, animation: true)
				self.showSmallPlayBar(percentage: 1)
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
	
	private func showSmallPlayBar(percentage: CGFloat) {
		self.playingView.smallPlayBar.alpha = percentage
		self.playingView.dropdownImage.alpha = 1 - percentage * 3
	}
}

