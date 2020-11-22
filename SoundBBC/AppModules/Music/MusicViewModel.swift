//
//  MusicViewModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/16/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MusicViewModel: BaseViewModel {
	
	private let dataSource = BehaviorRelay<[DisplayModuleModel]>(value: [])
	private var cellViewModels: [[ListenCellViewModel]] = []
	
	// Input
	let reloadData = PublishSubject<Void>()
	
	// Output
	let refreshView = PublishSubject<Void>()
	
	override init() {
		super.init()
		
		reloadData.asObservable()
			.throttle(.seconds(5), scheduler: MainScheduler.instance)
			.flatMapLatest {
				return AppRequest(.listen).request([DisplayModuleModel].self)
			}
			.subscribe(onNext: { [weak self] result in
				if let data = try? result.get() {
					let items = data.filter { $0.state == "ok" }
					self?.dataSource.accept(items)
					self?.cellViewModels = items.map { ($0.data ?? []) }
						.map { items -> [ListenCellViewModel] in
							items.map { ListenCellViewModel(data: $0) }
						}
					self?.refreshView.onNext(())
				}
			})
			.disposed(by: disposeBag)
		
		reloadData.onNext(())
	}
}


// MARK: - ColelctionView
extension MusicViewModel {
	func theme(forSection index: Int) -> LayoutProvider.AppElementTheme {
		if let style = dataSource.value[safe: index]?.style {
			return LayoutProvider.AppElementTheme(rawValue: style) ?? .unknown
		}
		guard let id = dataSource.value[safe: index]?.id else { return .unknown }
		return AppConfiguration.shared.theme(id: id)
	}
	
	func numberOfSection() -> Int {
		return self.dataSource.value.count
	}
	
	func numberOfItems(inSection index: Int) -> Int {
		let theme = self.theme(forSection: index)
		if theme == .dial {
			return 1
		} else {
			return dataSource.value[safe: index]?.data?.count ?? 0
		}
	}
}

