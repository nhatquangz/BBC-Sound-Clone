//
//  PlayingViewModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/3/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MediaPlayer

enum PlayingViewPosition {
	case full, mini, hide
}

class PlayingViewModel {
	
	static let shared = PlayingViewModel()
	var disposeBag = DisposeBag()
	
	/// UI output
	let songImage = BehaviorRelay<URL?>(value: nil)
	let songTitle = BehaviorRelay<String>(value: "")
	let songDescription = BehaviorRelay<String>(value: "")
	let duration = BehaviorRelay<Double>(value: 0)
	let currentTimeString = BehaviorRelay<String>(value: "0:00")
	let playingTrackValue = PublishSubject<Float>()
	
	/// Position of playing view
	let position = BehaviorRelay<PlayingViewPosition>(value: .hide)
	
	private let player = PlayerController()
	let playingState = BehaviorRelay<PlayerController.PlayingState>(value: (id: "", isPlay: false))
	let play = PublishSubject<DisplayItemModel?>()
	let pause = PublishSubject<Void>()
	let rewindAmount = PublishSubject<Double>()
	let isSeeking = PublishSubject<Bool>()
	let seekTime = PublishSubject<Double>()
	
	init() {
		_ = rewindAmount.bind(to: player.rewindAmount)
		_ = isSeeking.bind(to: player.isSeeking)
		_ = seekTime.bind(to: player.seekTime)
		
		_ = player.timeObservable.map { Float($0) }.bind(to: playingTrackValue)
		_ = player.timeObservable.map { $0.asString(style: .positional) }
			.bind(to: currentTimeString)
		_ = player.playingState.bind(to: playingState)
		
		_ = play.asObserver()
			.subscribe(onNext: { [weak self] item in
				if let item = item {
					self?.load(item)
					if self?.position.value == .hide {
						self?.position.accept(.full)
					}
				} else {
					self?.player.changePlayerState()
				}
			})
	}
	
	func load(_ item: DisplayItemModel, playAfterLoading shoudPlay: Bool = true) {
		guard let itemID = item.id else { return }
		self.updateItem(item)
		var preSeekValue = item.progress?.value
		if item.currentProgress() == 1 {
			preSeekValue = nil
		}
		self.player.load(itemID, seekTo: preSeekValue, shouldPlay: shoudPlay)
	}
}


extension PlayingViewModel {
	private func updateItem(_ item: DisplayItemModel?) {
		guard let item = item else { return }
		let imageURL = item.imageUrl?.bbc.replace([.recipe: "432x432"]).urlEncoded
		songImage.accept(imageURL)
		songTitle.accept(item.titles?.primary ?? "")
		songDescription.accept("\(item.titles?.secondary ?? "")\n\(item.titles?.tertiary ?? "")")
		duration.accept(item.duration?.value ?? 0)
		/// Save the last item's id to show playbar for the next time opening app
		UserDefaults.standard.setValue(item.id, forKey: "lastItem")
	}
}

