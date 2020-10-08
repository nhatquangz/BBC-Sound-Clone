//
//  ListenViewModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 6/30/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class ListenViewModel: BaseViewModel {
	
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
			.flatMapLatest { _ -> Observable<Result<[DisplayModuleModel], RequestError>> in
				return AppRequest.get(.listen)
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


// MARK: - CollectionView
extension ListenViewModel {
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
	
	func items(section: Int) -> [DisplayItemModel] {
		return self.dataSource.value[safe: section]?.data ?? []
	}
	
	func item(indexPath: IndexPath) -> DisplayItemModel? {
		let section = indexPath.section
		let itemIndex = indexPath.row
		return self.dataSource.value[safe: section]?.data?[safe: itemIndex]
	}
	
	func viewModel(indexPath: IndexPath) -> ListenCellViewModel? {
		let section = indexPath.section
		let itemIndex = indexPath.row
		return self.cellViewModels[safe: section]?[safe: itemIndex]
	}
	
	func headerViewModel(index: IndexPath) -> DefaultHeaderViewModel? {
		guard let itemData = dataSource.value[safe: index.section] else { return nil }
		return DefaultHeaderViewModel(section: itemData)
	}
}

