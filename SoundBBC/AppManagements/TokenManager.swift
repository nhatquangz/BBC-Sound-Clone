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
	
	static let shared = TokenManager()
	
	init() {
		if let data = try? keychain.getData(storagePath) {
			let token = JSON(data)
			self.accessToken = token["access_token"].stringValue
			self.refreshToken = token["refresh_token"].stringValue
		}
	}
	
	func refresh(completion: @escaping (Result<JSON, RequestError>) -> Void) {
		AppRequest.refreshToken(token: refreshToken) { result in
			if let token = try? result.get() {
				self.update(jsonToken: token["tokens"])
			}
			completion(result)
		}
	}
	
	func update(jsonToken: JSON) {
		if let data = try? jsonToken.rawData() {
			keychain[data: storagePath] = data
		}
		self.accessToken = jsonToken["access_token"].stringValue
		self.refreshToken = jsonToken["refresh_token"].stringValue
	}
	
}

