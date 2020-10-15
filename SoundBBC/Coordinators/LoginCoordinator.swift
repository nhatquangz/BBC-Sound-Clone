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
	
	enum Action {
		case login, register
	}
	
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
	
	func request(_ action: Action, challengeCode: String) {
		var key = ""
		switch action {
		case .login: key = "signInUrl"
		case .register: key = "registerUrl"
		}
		guard let url = AppConfiguration.shared.idctaConfig(["federated", key]),
			  var requestURL = URLComponents(string: url) else { return }
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
		requestURL.queryItems = queries
		
		if let url = requestURL.url {
			let sf = SFSafariViewController(url: url)
			self.navigationController.present(sf, animated: true)
		}
	}
}
