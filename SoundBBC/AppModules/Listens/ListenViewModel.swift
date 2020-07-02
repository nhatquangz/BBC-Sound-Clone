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
	
	// Input
	let reloadData = PublishSubject<Void>()
	
	// Output
	let refreshView = PublishSubject<Void>()
	
	override init() {
		super.init()
		
		reloadData.asObservable()
			.throttle(.seconds(5), scheduler: MainScheduler.instance)
			.flatMapLatest { _ -> Observable<Result<[DisplayModuleModel], RequestError>> in
				return AppRequest.get(path: .listen)
			}
			.subscribe(onNext: { [weak self] result in
				if let data = try? result.get() {
					self?.dataSource.accept([data[1]])
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
		guard let id = dataSource.value[safe: index]?.id else {
			return .unknown
		}
		return AppConfiguration.shared.theme(id: id)
	}
	
	func snapshotData() -> NSDiffableDataSourceSnapshot<String, DisplayItemModel> {
		var snapshot = NSDiffableDataSourceSnapshot<String, DisplayItemModel>()
		self.dataSource.value.forEach { (section) in
			snapshot.appendSections([section.id])
			snapshot.appendItems(section.data, toSection: section.id)
		}
		return snapshot
	}
}

