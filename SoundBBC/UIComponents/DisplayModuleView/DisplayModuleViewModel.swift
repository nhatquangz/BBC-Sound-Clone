//
//  DisplayModuleViewModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class DisplayModuleViewModel {
	
	let disposeBag = DisposeBag()
	
	var data: DisplayModuleData
	var itemType: DisplayableItemType
	var itemSize: CGSize
	
	init(data: DisplayModuleData,
		 itemType: DisplayableItemType) {
		
		self.data = data
		self.itemType = itemType
		
		itemSize = itemType.defaultSize()
	}
}
