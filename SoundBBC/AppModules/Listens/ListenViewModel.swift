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
					self?.dataSource.accept(data)
					self?.refreshView.onNext(())
				}
			})
			.disposed(by: disposeBag)
		
		
		
		reloadData.onNext(())
	}
}


// MARK: - CollectionView
extension ListenViewModel {
	func numberOfSection() -> Int {
		return dataSource.value.count
	}
	
	func numberOfItems(inSection index: Int) -> Int {
		return dataSource.value[safe: index]?.data.count ?? 0
	}
	
	func theme(forSection index: Int) -> LayoutProvider.AppElementTheme {
		guard let id = dataSource.value[safe: index]?.id else {
			return .unknown
		}
		return AppConfiguration.shared.theme(id: id)
	}
}

