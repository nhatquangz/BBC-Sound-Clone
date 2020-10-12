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
			if progress != 1 {
				dateTimeText.accept(data.progress?.label ?? "")
			} else {
				dateTimeText.accept("Listened")
			}
			showProgressBar.accept(true)
			currentProgress.accept(progress)
		} else {
			dateTimeText.accept(data.duration?.label ?? "")
			showProgressBar.accept(false)
		}
		
		/// Playing
		playItem.withLatestFrom(playingState)
			.throttle(.seconds(1), scheduler: MainScheduler.instance)
			.subscribe(onNext: { [weak self] (isPlaying) in
				guard let self = self else { return }
				if !isPlaying {
					PlayingViewModel.shared.play.onNext(self.data)
				} else {
					PlayingViewModel.shared.pause.onNext(())
				}
			})
			.disposed(by: disposeBag)

		
		// Update playing state
		PlayingViewModel.shared.playingState
			.flatMapLatest { [weak self] playingItem -> Observable<Bool> in
				guard let itemID = self?.data.id else {
					return Observable.empty()
				}
				/// state changes happening from playingview
				if itemID == playingItem.id {
					return Observable.just(playingItem.isPlay)
				}
				/// State changes happening from another item
				/// Change state of current item to stop
				return .just(false)
			}
			.bind(to: playingState)
			.disposed(by: disposeBag)
		
		/// Update process from playingview if need be
		let timeObserver = PlayingViewModel.shared.timeObservable.asObserver()
		let playingItem = PlayingViewModel.shared.playingState.asObservable()
		Observable<Float>.combineLatest(timeObserver, playingItem) { [weak self] (time, item) -> Float in
			/// Make sure that playing item is local item
			guard let self = self,
				  let itemID = self.data.id,
				  itemID == item.id,
				  let duration = self.data.duration?.value else { return -1 }
			let percentage = Float(time/duration)
			let remainTime = duration - time
			if percentage >= 1 {
				self.dateTimeText.accept("Listened")
			} else {
				self.dateTimeText.accept(remainTime.minuteRemain())
			}
			return percentage
		}
		.bind(to: currentProgress)
		.disposed(by: disposeBag)
		
		/// Setup the last item if there are no item playing
		let lastItemID = UserDefaults.standard.string(forKey: "lastItem")
		let playingViewPosition = PlayingViewModel.shared.position.value
		if lastItemID == self.data.id, playingViewPosition == .hide {
			PlayingViewModel.shared.load(self.data, playAfterLoading: false)
			PlayingViewModel.shared.position.accept(.mini)
		}
	}
	
	func imageURL(placeholders: String.Placeholder) -> URL? {
		return data.imageUrl?.bbc.replace(placeholders).urlEncoded
	}
}

