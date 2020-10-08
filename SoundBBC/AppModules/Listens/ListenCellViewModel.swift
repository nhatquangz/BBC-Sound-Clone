//
//  ListenCellViewModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/1/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt


class ListenCellViewModel: BaseViewModel {
	
	// Output
	//	let imageURL = BehaviorRelay<URL?>(value: nil)
	let title = BehaviorRelay<String>(value: "")
	let secondaryTitle = BehaviorRelay<String>(value: "")
	let tertiaryTitle = BehaviorRelay<String>(value: "")
	let synopses = BehaviorRelay<String>(value: "")
	let descriptionText = BehaviorRelay<String>(value: "")
	let dateTimeText = BehaviorRelay<String>(value: "")
	let showProgressBar = BehaviorRelay<Bool>(value: false)
	let currentProgress = BehaviorRelay<Float>(value: 0)
	let playingState = BehaviorRelay<Bool>(value: false)
	
	// Input
	let playItem = PublishSubject<Void>()
	
	private let data: DisplayItemModel
	
	init(data: DisplayItemModel) {
		self.data = data
		super.init()
		title.accept(data.titles?.primary ?? "")
		secondaryTitle.accept(data.titles?.secondary ?? "")
		tertiaryTitle.accept(data.titles?.tertiary ?? "")
		descriptionText.accept("\(data.titles?.secondary ?? "")\n\(data.titles?.tertiary ?? "")")
		synopses.accept(data.synopses?.short ?? "")
		
		if let progress = data.currentProgress() {
			dateTimeText.accept(data.progress?.label ?? "")
			showProgressBar.accept(false)
			currentProgress.accept(progress)
		} else {
			dateTimeText.accept(data.duration?.label ?? "")
			showProgressBar.accept(true)
		}
		
		/// Playing
		playItem.withLatestFrom(playingState)
			.throttle(.seconds(1), scheduler: MainScheduler.instance)
			.map { !$0 }
			.subscribe(onNext: { [weak self] (isPlaying) in
				guard let self = self else { return }
				PlayingViewModel.shared.changePosition.onNext(.mini)
				if isPlaying {
					PlayingViewModel.shared.play.onNext(self.data)
					self.playingState.accept(true)
				} else {
					self.playingState.accept(false)
					PlayingViewModel.shared.pause.onNext(())
				}
			})
			.disposed(by: disposeBag)

		
		// Update playing state
		PlayingViewModel.shared.playingStateObservable
			.flatMapLatest { [weak self] currentItem -> Observable<Bool> in
				guard let itemID = self?.data.id else {
					return Observable.empty()
				}
				/// state changes happening from playingview
				if itemID == currentItem.id {
					return Observable.just(currentItem.isPlay)
				}
				/// State changes happening from another item
				/// Update state current item to stop
				return .just(false)
			}
			.bind(to: playingState)
			.disposed(by: disposeBag)
	}
	
	func imageURL(placeholders: String.Placeholder) -> URL? {
		return data.imageUrl?.bbc.replace(placeholders).urlEncoded
	}
}

