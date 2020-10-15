//
//  SplashViewController.swift
//  SoundBBC
//
//  Created by nhatquangz on 6/29/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import AVFoundation


class SplashViewController: UIViewController {

	let disposeBag = DisposeBag()
	weak var cooridinator: AppCoordinator?
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
}



// MARK: - Init function
extension SplashViewController {
	func setup() {
		/// Request config data
		AppRequest.getJSON(.config, retryCount: 100)
			.flatMapLatest { (result) -> Observable<Result<JSON, RequestError>> in
				if let config = try? result.get() {
					AppConfiguration.shared.setup(config: config)
					let idctaURL = config["idv5Config"]["idctaConfigURL"].stringValue
					return AppRequest.getJSON(idctaURL)
				} else {
					return Observable.empty()
				}
			}
			.subscribe(onNext: { result in
				if let config = try? result.get() {
					AppConfiguration.shared.setup(idctaConfig: config)
					if self.isLogin() {
						self.cooridinator?.tabbar()
					} else {
						self.cooridinator?.login()
					}
				}
			})
		.disposed(by: disposeBag)
		
		/// Audio
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowAirPlay])
			print("Playback OK")
			try AVAudioSession.sharedInstance().setActive(true)
			print("Session is Active")
		} catch {
			print(error)
		}
	}
	
	func isLogin() -> Bool {
		guard TokenManager.shared.accessToken != "", TokenManager.shared.refreshToken != "" else  { return false }
		return true
	}
}

