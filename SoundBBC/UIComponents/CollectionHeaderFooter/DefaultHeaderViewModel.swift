//
//  DefaultHeaderViewModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/2/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class DefaultHeaderViewModel {
	
	// Output
	let sectionTitle = BehaviorRelay<String>(value: "")
	let isShowButton = BehaviorRelay<Bool>(value: false)
	
	// Input
	let seeMoreAction = PublishSubject<Void>()
	
	
	init(section: DisplayModuleModel) {
		sectionTitle.accept(section.title ?? "")
		isShowButton.accept(section.id == "categories")
	}
}
