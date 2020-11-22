//
//  AppNetwork.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import RxSwiftExt
import SwiftyJSON


enum RequestError: Error {
	case serverError(Any?)
	case offline
}

class Networking: NSObject {
	
	static let shared = Networking()
	
	var defaultSession: Session!
	let kTimeoutIntervalForRequest = 30
	
	override init() {
		super.init()
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = TimeInterval(kTimeoutIntervalForRequest)
		defaultSession = Session(configuration: configuration,
								 interceptor: RequestInterceptor(storage: TokenManager.shared))
	}
}


// MARK: - Method
extension Networking {
	func request(method: HTTPMethod,
				 url: String,
				 parameters: [String : Any]? = nil,
				 encoding: ParameterEncoding = JSONEncoding.default,
				 header: HTTPHeaders? = nil,
				 session: Session? = nil,
				 retryCount: Int = 1) -> Observable<Result<Any, RequestError>> {
		print("\(method.rawValue): \(url)")
		let session: Session = session ?? self.defaultSession
		return Observable<Result<Any, RequestError>>.create { observer -> Disposable in
			session.request(url, method: method, parameters: parameters, encoding: encoding, headers: header)
				.validate(statusCode: 200..<300)
				.responseJSON { response in
					switch response.result {
					case .success(let value):
						observer.onNext(.success(value))
					case .failure(_):
						observer.onError(RequestError.serverError(response.data))
					}
					observer.onCompleted()
			}
			return Disposables.create()
			}
			.retry(.delayed(maxCount: UInt(retryCount), time: 5))
			.catchError({ error -> Observable<Result<Any, RequestError>> in
				return Observable.just(.failure(error as! RequestError))
			})
	}
}
