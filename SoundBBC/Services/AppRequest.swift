//
//  AppRequest.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift
import Alamofire


class AppRequest {
	
	static func get(path: RequestPath, retryCount: Int = 2) -> Observable<Result<JSON, RequestError>> {
		return Networking.shared.request(method: .get, url: path.url, retryCount: retryCount)
	}
	
	static func post(path: RequestPath, retryCount: Int = 2) -> Observable<Result<JSON, RequestError>> {
		return Networking.shared.request(method: .post, url: path.url, retryCount: retryCount)
	}
	
	static func getConfig() -> Observable<Result<JSON, RequestError>> {
		let path = AppEnvironment.shared.current.appConfigURL
		return Networking.shared.request(method: .get, url: path)
	}
	
	
	/// Get array data from returned json
	/// - Parameters:
	///   - path: request path
	///   - retryCount: number of retring the request
	/// - Returns: Array of expected data model
	static func get<T>(path: RequestPath, retryCount: Int = 2) -> Observable<Result<[T], RequestError>> where T: DecodableModelProtocol {
		return Networking.shared.request(method: .get, url: path.url, retryCount: retryCount)
			.map { result -> Result<[T], RequestError> in
				return result.map { jsonData -> [T] in
					return jsonData["data"].arrayValue.map { T($0) }
				}
		}
	}
}
