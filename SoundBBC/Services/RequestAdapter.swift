//
//  RequestAdapter.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/1/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// The storage containing your access token, preferable a Keychain wrapper.
protocol AccessTokenStorage: class {
	var accessToken: String { get set }
	func refresh(completion: @escaping (Result<JSON, RequestError>) -> Void)
}


class RequestInterceptor: Alamofire.RequestInterceptor {
	
	private var storage: AccessTokenStorage
	private let ignoreTokenList = ["open.live.bbc.uk"]
	
	init(storage: AccessTokenStorage) {
		self.storage = storage
	}
	
	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
		var urlRequest = urlRequest
		if needToken(for: urlRequest.url) {
			urlRequest.setValue("Bearer " + storage.accessToken, forHTTPHeaderField: "Authorization")
		}
		urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		completion(.success(urlRequest))
	}
	
	func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
		guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
			/// The request did not fail due to a 401 Unauthorized response.
			/// Return the original error and don't retry the request.
			return completion(.doNotRetryWithError(error))
		}
		print("Refresh token")
		storage.refresh { result in
			switch result {
			case .success:
				completion(.retry)
			case .failure(let error):
				completion(.doNotRetryWithError(error))
			}
		}
	}
	
	private func needToken(for url: URL?) -> Bool {
		return url?.absoluteString.contains("open.live.bbc.uk") ?? false
	}
}

