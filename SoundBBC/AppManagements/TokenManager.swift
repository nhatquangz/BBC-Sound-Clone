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
	var refreshToken: String = "eyJ0eXAiOiJKV1QiLCJ6aXAiOiJOT05FIiwia2lkIjoiRWdVVSs4TmhhQVlLYzZ5bG9DQnJuS1BUY2U4PSIsImFsZyI6IkVTMjU2In0.eyJzdWIiOiIxMzk1ZWE4ZC0xNDcwLTQzYWYtOGUzMS1iZDg3MmU5ZTg2MjMiLCJjdHMiOiJPQVVUSDJfU1RBVEVMRVNTX0dSQU5UIiwiYXV0aF9sZXZlbCI6MiwiYXVkaXRUcmFja2luZ0lkIjoiYWJhOTJlZWEtNzExMC00NTVhLTkzOGQtZDQ5NTc1YThkMDMwLTExMDY2MTI1OCIsImlzcyI6Imh0dHBzOi8vYWNjZXNzLmFwaS5iYmMuY29tL2JiY2lkdjUvb2F1dGgyL05NQVJlYWxtIiwidG9rZW5OYW1lIjoicmVmcmVzaF90b2tlbiIsImF1dGhNb2R1bGVzIjoiQkJDSURfRU1BSUwiLCJ0b2tlbl90eXBlIjoiQmVhcmVyIiwiYXV0aEdyYW50SWQiOiJZNEpid1lRMEpEQ3Z5SDRfYjBHWFBka0xQb1EiLCJhdWQiOiJpUGxheWVyTk1BIiwiYWNyIjoiMCIsIm5iZiI6MTU4MDE2MDc2MywiZ3JhbnRfdHlwZSI6ImF1dGhvcml6YXRpb25fY29kZSIsInNjb3BlIjpbImV4cGxpY2l0IiwiY29yZSIsImltcGxpY2l0IiwicGlpIiwidWlkIiwib3BlbmlkIl0sImF1dGhfdGltZSI6MTU4MDE2MDc2MiwicmVhbG0iOiIvTk1BUmVhbG0iLCJleHAiOjE2NDMyMzI3NjMsImlhdCI6MTU4MDE2MDc2MywiZXhwaXJlc19pbiI6NjMwNzIwMDAsImp0aSI6ImFlTkpPbmxDY0hEMm5MUUN5eHBFVWpSSkdyUSJ9.l7d9fah2Pj1uzpgZ0IOkDjmh56s7m2I7viOieWNXoBMt7UXzVBY_YEAXYMwqN85R01KRNkDTpxhKBv_gD__hmQ"
	
	private let keychain = Keychain(service: "com.nhatquangz.soundbbc")
	private let storagePath = "tokens"
	
	init() {
		if let data = try? keychain.getData(storagePath) {
			let token = JSON(data)
			self.accessToken = token["tokens"]["access_token"].stringValue
			self.refreshToken = token["tokens"]["refresh_token"].stringValue
		}
	}
	
	func refresh(completion: @escaping (Result<JSON, RequestError>) -> Void) {
		AppRequest.refreshToken(token: refreshToken) { result in
			if let token = try? result.get() {
				self.update(jsonToken: token)
			}
			completion(result)
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
