//
//  ListenLiveViewModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/4/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ListenLiveViewModel {
	
	let disposeBag = DisposeBag()
	
	private var dataSource: [DisplayItemModel] = []
	
	let channelTitle = BehaviorRelay<String>(value: "")
	let channelDescription = BehaviorRelay<String>(value: "")
	let currentOffset = PublishRelay<CGFloat>()
	
	init(data: [DisplayItemModel]) {
		self.dataSource = data
		
		let itemHeight = AppDefinition.Dimension.dialItemHeight
		let itemSpace = AppDefinition.Dimension.itemSpace
		
		currentOffset.asObservable()
			.throttle(.milliseconds(100), scheduler: MainScheduler.instance)
			.subscribe(onNext: { [weak self] offsetX in
				let offsetCenterItem = offsetX + UIScreen.main.bounds.width / 2
				let currentIndex = Int(offsetCenterItem / (itemHeight + itemSpace))
				let data = self?.dataChannel(index: currentIndex)
				self?.channelTitle.accept(data?.network?.shortTitle ?? "")
				self?.channelDescription.accept(data?.titles?.primary ?? "")
			})
			.disposed(by: disposeBag)
		
	}
}


extension ListenLiveViewModel {
	func dataChannel(index: Int) -> DisplayItemModel? {
		if dataSource.count > 0 {
			return self.dataSource[safe: index % dataSource.count]
		}
		return nil
	}
}

