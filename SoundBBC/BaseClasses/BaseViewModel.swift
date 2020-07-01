//
//  BaseViewModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/1/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


enum ViewState {
	case normal
	case loading
	case noConnection
}


class BaseViewModel {
	let disposeBag = DisposeBag()
	var viewState = BehaviorRelay<ViewState>(value: .normal)
}
