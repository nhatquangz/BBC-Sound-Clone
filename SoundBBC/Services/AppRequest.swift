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
	
	static func getJSON(_ path: RequestPath, retryCount: Int = 2) -> Observable<Result<JSON, RequestError>> {
		return Networking.shared.request(method: .get, url: path.url(), retryCount: retryCount)
			.map { result -> Result<JSON, RequestError> in
				return result.map { data -> JSON in
					return JSON(data)
				}
			}
	}
	
	static func getJSON(_ path: String, retryCount: Int = 2) -> Observable<Result<JSON, RequestError>> {
		return Networking.shared.request(method: .get, url: path, retryCount: retryCount)
			.map { result -> Result<JSON, RequestError> in
				return result.map { data -> JSON in
					return JSON(data)
				}
			}
	}

	
	/// Get object data from returned json
	/// - Parameters:
	///   - path: request path
	///   - retryCount: number of retring the request
	///   - childs: get data's child path
	///   - placeholders: placeholder to be replaced in url
	/// - Returns: Object of expected data model
	static func get<T>(_ path: RequestPath,
					   retryCount: Int = 2,
					   childs: [JSONSubscriptType] = ["data"],
					   placeholders: String.Placeholder = [:]) -> Observable<Result<T?, RequestError>> where T: Decodable {
		return Networking.shared.request(method: .get, url: path.url(), retryCount: retryCount)
			.map { result -> Result<T?, RequestError> in
				return result.map { data -> T? in
					let jsonData = try? JSON(data)[childs].rawData()
					let object: T? = try? jsonData?.decoded()
					return object
				}
		}
	}
	
	/// Get array data from returned json
	/// - Parameters:
	///   - path: request path
	///   - retryCount: number of retring the request
	///   - childs: get data's child path
	/// - Returns: Array of expected data model
	static func get<T>(_ path: RequestPath,
					   retryCount: Int = 2,
					   childs: [JSONSubscriptType] = ["data"],
					   placeholders: String.Placeholder = [:]) -> Observable<Result<[T], RequestError>> where T: Decodable {
		return Networking.shared.request(method: .get, url: path.url(placeholders), retryCount: retryCount)
			.map { result -> Result<[T], RequestError> in
				return result.map { data -> [T] in
					let jsonData = try? JSON(data)[childs].rawData()
					let arrayData: [T] = jsonData?.decodedArray() ?? []
					return arrayData
				}
		}
	}
}


// MARK: - BBC
extension AppRequest {
	static func refreshToken(token: String, result: @escaping (Result<JSON, RequestError>) -> Void) {
		let parameter = ["cassoClientId": "soundsNMA",
						 "realm": "NMARealm",
						 "clientId": "iPlayerNMA"]
		let cookie = "ckns_rtkn=\(token)"
		AF.request(RequestPath.refreshToken.url(), parameters: parameter, headers: ["Cookie": cookie])
			.validate(statusCode: 200..<300)
			.responseJSON { (response) in
				switch response.result {
				case .success(let value):
					result(.success(JSON(value)))
				case .failure(_):
					result(.failure(RequestError.serverError(response.data)))
				}
		}
	}
}

