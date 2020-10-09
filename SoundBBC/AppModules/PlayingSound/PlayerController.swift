//
//  PlayerController.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/8/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import AVFoundation
import RxCocoa
import RxSwift


class PlayerController {
	
	var disposeBag = DisposeBag()
	
	// Player
	private var player: AVPlayer?
	private var currentItemID: String = ""
	private var timeObserverToken: Any?
	private let itemState = PublishSubject<AVPlayerItem.Status>()
	private let currentTime = PublishSubject<Double>()
	private var preSeekValue: Double?
	let isSeeking = PublishSubject<Bool>()
	let seekTime = PublishSubject<Double>()
	
	// Observer state of playingview
	typealias PlayingState = (id: String, isPlay: Bool)
	let playingState = BehaviorRelay<PlayingState>(value: (id: "", isPlay: false))
	
	let rewindAmount = PublishSubject<Double>()
	/// Value to update UIs
	let timeObservable = BehaviorRelay<Double>(value: 0)
	let duration = BehaviorRelay<Double>(value: 0)
	
	
	init() {
		let seekTimeObservable = seekTime.asObserver().share()
		
		/// Using seekTime + currentTime to update slider + circle progress's value
		/// Using currentTime value in normaly playing state
		/// Using seekTime value in seeking state
		/// There is only one observable emitting values at a time because we stop update currentTime when there are seeking events
		let currentTimeObservable = seekTimeObservable.merge(with: self.currentTime.asObserver())
		_ = currentTimeObservable.bind(to: timeObservable)
		
		/// Handle seeking request from slider
		_ = Observable.combineLatest(seekTimeObservable, isSeeking.asObservable())
			/// User is seeking, stop updating current time
			.do(onNext: { [weak self] _ in self?.removePeriodicTimeObserver() })
			.debounce(.milliseconds(500), scheduler: MainScheduler.instance)
			.subscribe(onNext: { [weak self] seekTime, isSeeking in
				// Make sure user no longer changes the slider's value
				if !isSeeking {
					self?.seek(to: seekTime)
				}
			})
		
		/// Handle seeking from buttons
		_ = rewindAmount.asObserver()
			/// User is seeking, stop updating current time
			.do(onNext: { [weak self] _ in self?.removePeriodicTimeObserver() })
			/// Calculate target value to seek
			.withLatestFrom(self.currentTime.asObserver()) { [weak self] (seekValue, currentTime) -> Double in
				guard let self = self else { return 0 }
				let duration = self.duration.value
				var targetTime = currentTime + seekValue
				if targetTime < 0 { targetTime = 0 }
				if targetTime > duration { targetTime = duration }
				return targetTime
			}
			.bind(to: seekTime, currentTime)
	}
}

// MARK: - Control
extension PlayerController {
	/// Handle playing request
	/// - Parameters:
	///   - itemID: player item id
	///   - seekTime: seek to specific value
	///   - shouldPlay: whether player should play after loading
	func load(_ itemID: String, seekTo seekTime: Double? = nil, shouldPlay: Bool = true) {
		/// If the same item was passed, play if need be
		guard itemID != currentItemID else {
			if shouldPlay { self.play() }
			return
		}
		self.currentItemID = itemID
		self.preSeekValue = seekTime
		// Get new item's url
		AppRequest.get(.playmedia,
					   childs: ["media"],
					   placeholders: [.vipd: itemID])
			.map { (result: Result<[MediaModel], RequestError>) -> URL? in
				return try? result.get().first?.connection?.first?.href?.urlEncoded
			}
			.subscribe(onNext: { [weak self] mediaURL in
				self?.setupPlayer(mediaURL, shouldPlay: shouldPlay)
			})
			.disposed(by: disposeBag)
	}
	
	/// Handle pause/play request
	/// Update state and pause player
	func pause() {
		guard let player = self.player else { return }
		player.pause()
		self.playingState.accept((id: currentItemID, isPlay: false))
	}
	
	/// Play current item if any
	func play() {
		guard let player = self.player else { return }
		player.play()
		self.playingState.accept((id: currentItemID, isPlay: true))
	}
	
	// Play/Pause current item
	func changePlayerState() {
		let currentState = self.player?.timeControlStatus
		currentState == .paused ? self.play() : self.pause()
	}
}


// MARK: - Prepare to play
extension PlayerController {
	private func setupPlayer(_ url: URL? = nil, shouldPlay: Bool = true) {
		guard let url = url else { return }
		/// Remove the old observer
		disposeBag = DisposeBag()
		let playerItem = AVPlayerItem(url: url)
		/// Observe player item status
		playerItem.rx.observeWeakly(Int.self, #keyPath(AVPlayerItem.status))
			.subscribe(onNext: { [weak self] status in
				print("☀️ Item State: \(status)")
				if status == 1 {
					self?.duration.accept(playerItem.duration.seconds)
					if let preSeekValue = self?.preSeekValue {
						self?.preSeekValue = nil
						self?.player?.pause()
						self?.seekTime.onNext(preSeekValue)
					}
				}
			})
			.disposed(by: disposeBag)
		
		self.removePeriodicTimeObserver()
		self.player = AVPlayer(playerItem: playerItem)
		/// Observe current time if there is no need to pre-seek
		if preSeekValue == nil {
			self.addPeriodicTimeObserver()
		}
		if shouldPlay {
			self.play()
		}
	}
}


// MARK: - Track player's time
extension PlayerController {
	private func addPeriodicTimeObserver() {
		guard let player = self.player else { return }
		let timeScale = CMTimeScale(NSEC_PER_SEC)
		let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
		print("Add time observer")
		timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
														   queue: .main) {
			[weak self] time in
			self?.currentTime.onNext(time.seconds)
			print("Update time: \(time.seconds)")
		}
	}
	
	private func removePeriodicTimeObserver() {
		if let timeObserverToken = timeObserverToken {
			player?.removeTimeObserver(timeObserverToken)
			self.timeObserverToken = nil
			print("Remove time observer")
		}
	}
	
	private func seek(to time: Double) {
		guard self.player?.status == .readyToPlay else { return }
		self.removePeriodicTimeObserver()
		print("Start seeking to \(time)")
		let seekTime = CMTime(seconds: time, preferredTimescale: 2)
		self.player?.currentItem?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { [weak self] (isFinish) in
			print("Seek to \(time) result: \(isFinish)")
			if isFinish {
				self?.addPeriodicTimeObserver()
				let isPlay = self?.playingState.value.isPlay ?? false
				/// Play again if player was paused by seeking pre-value
				if isPlay { self?.player?.play() }
			}
		})
	}
}
