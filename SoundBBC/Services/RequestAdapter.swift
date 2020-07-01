//
//  RequestAdapter.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/1/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import Alamofire

/// The storage containing your access token, preferable a Keychain wrapper.
protocol AccessTokenStorage: class {
	typealias JWT = String
	var accessToken: JWT { get set }
}


class RequestInterceptor: Alamofire.RequestInterceptor {
	typealias RefreshToken = (Result<String, Error>) -> Void
	
	private var storage: AccessTokenStorage
	private var refreshToken: ((RefreshToken) -> Void)?
	
	init(storage: AccessTokenStorage, refreshToken: ((RefreshToken) -> Void)? = nil) {
		self.storage = storage
		self.refreshToken = refreshToken
	}
	
	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
		var urlRequest = urlRequest
		urlRequest.setValue("Bearer " + storage.accessToken, forHTTPHeaderField: "Authorization")
		completion(.success(urlRequest))
	}
	
	func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
		guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
			/// The request did not fail due to a 401 Unauthorized response.
			/// Return the original error and don't retry the request.
			return completion(.doNotRetryWithError(error))
		}
		print("Refresh token")
		refreshToken? { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let token):
				self.storage.accessToken = token
				completion(.retry)
			case .failure(let error):
				completion(.doNotRetryWithError(error))
			}
		}
	}
}

