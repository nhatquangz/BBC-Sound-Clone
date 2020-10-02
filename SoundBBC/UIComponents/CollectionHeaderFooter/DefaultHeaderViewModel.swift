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
	let observableSectionTitle = BehaviorRelay<String>(value: "")
	
	// Input
	let seeMoreAction = PublishRelay<Void>()
	
	
	init(section: DisplayModuleModel) {
		observableSectionTitle.accept(section.title ?? "")
	}
}
