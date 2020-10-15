//
//  LoginCoordinator.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/14/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class LoginCoordinator: BaseCoordinator {
	
	override func start() {
		let loginViewController = LoginViewController()
		loginViewController.coordinator = self
		self.navigationController.setViewControllers([loginViewController], animated: true)
	}
	
	func tabbar() {
		self.navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
		let tabCooridinator = TabbarCoordinator(navigation: self.navigationController)
		start(coordinator: tabCooridinator)
	}
	
	func login(challengeCode: String) {
		guard let url = AppConfiguration.shared.idctaConfig(["federated","signInUrl"]),
			  var loginURL = URLComponents(string: url) else { return }
		
		let param: [String: String] = [
			"tld": "co.uk",
			"thirdPartyRedirectUri": "uk.co.bbc.sound://oauth.callback",
			"clientId":	"soundsNMA",
			"realm": "NMARealm",
			"isCasso": "true",
			"userOrigin": "soundsNMA",
			"context": "default",
			"codeChallenge": challengeCode]
		let queries = param.map { URLQueryItem(name: $0.key, value: $0.value) }
		loginURL.queryItems = queries
		
		if let loginURL = loginURL.url {
			let sf = SFSafariViewController(url: loginURL)
			self.navigationController.present(sf, animated: true)
		}
	}
	
	func register() {
		guard let url = AppConfiguration.shared.idctaConfig(["federated","registerUrl"]),
			  var loginURL = URLComponents(string: url) else { return }
		
		loginURL.queryItems = [URLQueryItem(name: "thirdPartyRedirectUri", value: "uk.co.bbc.sounds://oauth.callback")]
		if let loginURL = loginURL.url {
			let sf = SFSafariViewController(url: loginURL)
			self.navigationController.present(sf, animated: true)
		}
	}
}
