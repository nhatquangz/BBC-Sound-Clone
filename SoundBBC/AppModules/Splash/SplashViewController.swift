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
import RxSwiftExt

class SplashViewController: UIViewController {

	
	// MARK: - Outlet

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
		AppRequest.get(path: .config).subscribe(onNext: { [weak self] result in
			if let config = try? result.get() {
				AppConfiguration.shared.setup(config: config)
				self?.cooridinator?.startTabbar()
			}
		})
		.disposed(by: disposeBag)
	}
}

