//
//  KeychainManager.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/1/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON
import KeychainAccess


class TokenManager: AccessTokenStorage {
	
	var accessToken: String = ""
	var refreshToken: String = ""
	
	private let keychain = Keychain(service: "com.nhatquangz.soundbbc")
	private let storagePath = "tokens"
	
	init() {
		if let data = try? keychain.getData(storagePath) {
			let token = JSON(data)
			self.accessToken = token["tokens"]["access_token"].stringValue
			self.refreshToken = token["tokens"]["refresh_token"].stringValue
		}
	}
	
	func refresh(completion: @escaping (RequestError?) -> Void) {
		AppRequest.refreshToken(token: refreshToken) { result in
			switch result {
			case .success(let jsonToken):
				self.update(jsonToken: jsonToken)
				completion(nil)
			case .failure(let error):
				completion(error)
			}
		}
	}
	
	private func update(jsonToken: JSON) {
		if let data = try? jsonToken.rawData() {
			keychain[data: storagePath] = data
		}
		self.accessToken = jsonToken["tokens"]["access_token"].stringValue
		self.refreshToken = jsonToken["tokens"]["refresh_token"].stringValue
	}
	
}
