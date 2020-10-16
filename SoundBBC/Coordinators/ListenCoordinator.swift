//
//  ListenCoordinator.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift


class ListenCoordinator: BaseCoordinator {
	
	/// Service to use for listen / music screen
	var dataObservable: Observable<Result<[DisplayModuleModel], RequestError>> = AppRequest.request(.listen)
	var title: String = ""
	
	override func start() {
		let viewModel = ListenViewModel(dataObservable: dataObservable)
		let listenVC = ListenViewController(viewModel: viewModel)
		listenVC.title = title
		self.navigationController.viewControllers = [listenVC]
	}
	
}
