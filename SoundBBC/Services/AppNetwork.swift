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
								 interceptor: RequestInterceptor(storage: TokenManager()))
	}
}


// MARK: - Method
extension Networking {
	func request(method: HTTPMethod,
				 url: String,
				 parameters: [String : Any]? = nil,
				 encoding: ParameterEncoding = URLEncoding.default,
				 session: Session? = nil,
				 retryCount: Int = 1) -> Observable<Result<JSON, RequestError>> {
		print("\(method.rawValue): \(url)")
		let session: Session = session ?? self.defaultSession
		return Observable<Result<JSON, RequestError>>.create { observer -> Disposable in
			session.request(url, method: method, parameters: parameters, encoding: encoding)
				.validate(statusCode: 200..<300)
				.responseJSON { response in
					switch response.result {
					case .success(let value):
						observer.onNext(.success(JSON(value)))
					case .failure(_):
						observer.onError(RequestError.serverError(response.data))
					}
					observer.onCompleted()
			}
			return Disposables.create()
			}
			.retry(.delayed(maxCount: UInt(retryCount), time: 5))
			.catchError({ error -> Observable<Result<JSON, RequestError>> in
				return Observable.just(.failure(error as! RequestError))
			})
	}
}
