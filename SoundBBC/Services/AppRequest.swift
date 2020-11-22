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
	
	private(set) var url: String
	private(set) var method: HTTPMethod = .get
	private(set) var parameters: [String: Any]?
	private(set) var childs: [JSONSubscriptType] = ["data"]
	private(set) var retryCount: Int = 2
	private(set) var header: HTTPHeaders?
	
	init(_ url: String) {
		self.url = url
	}
	
	init(_ requestPath: RequestPath, placeholders: String.Placeholder = [:]) {
		self.url = requestPath.url(placeholders)
	}
	
	func setURL(_ url: String) -> AppRequest {
		self.url = url
		return self
	}
	
	func setMethod(_ method: HTTPMethod) -> AppRequest {
		self.method = method
		return self
	}
	
	func setParameters(_ param: [String: Any]) -> AppRequest {
		self.parameters = param
		return self
	}
	
	func setDataPath(_ path: [JSONSubscriptType]) -> AppRequest {
		self.childs = path
		return self
	}
	
	func setRetry(_ count: Int) -> AppRequest {
		self.retryCount = count
		return self
	}
	
	func setHeader(header: HTTPHeaders) -> AppRequest {
		self.header = header
		return self
	}
	
	func request<T>(_ type: T.Type? = nil) -> Observable<Result<T, RequestError>> where T: Decodable {
		return Networking.shared.request(method: method,
										 url: url,
										 parameters: parameters,
										 header: header,
										 retryCount: retryCount)
			.flatMapLatest { result -> Observable<Result<T, RequestError>> in
				switch result {
				case .success(let data):
					if let object: T = try? JSON(data)[self.childs].rawData().decoded() {
						return .just(.success(object))
					} else if T.self == JSON.self {
						return .just(.success(JSON(data) as! T))
					} else {
						debugPrint("Wrong data type")
						return .empty()
					}
				case .failure(let error):
					return .just(.failure(error))
				}
			}
	}
}


// MARK: - BBC
extension AppRequest {
	static func refreshToken(token: String, result: @escaping (Result<JSON, RequestError>) -> Void) {
		let parameter = ["cassoClientId": "soundsNMA",
						 "realm": "NMARealm",
						 "clientId": "soundsNMA"]
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
	
	static func getToken(code: String, verifyCode: String) -> Observable<Result<JSON, RequestError>> {
		let callback = AppConfiguration.shared.idctaConfig(["federated", "callbackUrl"]) ?? ""
		var callbackURL = URLComponents(string: callback)
		callbackURL?.queryItems = [URLQueryItem(name: "clientId", value: "soundsNMA"),
								   URLQueryItem(name: "realm", value: "NMARealm")]
		guard let url = callbackURL?.url?.absoluteString else { return .empty() }
		let param = ["code": code,
					 "code_verifier": verifyCode]
		return AppRequest(url).setMethod(.post)
			.setParameters(param)
			.request()
	}
}

