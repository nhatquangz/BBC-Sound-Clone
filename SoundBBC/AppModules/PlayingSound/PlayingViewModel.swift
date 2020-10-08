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
	
	////
	let changePosition = PublishSubject<PlayingViewPosition>()
	let position = BehaviorRelay<PlayingViewPosition>(value: .hide)
	
	// Observer state of playingview
	typealias PlayingState = (id: String, isPlay: Bool)
	private let playingState = BehaviorRelay<PlayingState>(value: (id: "", isPlay: false))
	let playingStateObservable: Observable<PlayingState>
	
	// Player
	private var player: AVPlayer? {
		didSet {
			self.addPeriodicTimeObserver()
		}
	}
	private var currentItem: DisplayItemModel? {
		didSet {
			self.updateItemDetail(currentItem)
		}
	}
	private var timeObserverToken: Any?
	private let itemState = PublishSubject<AVPlayerItem.Status>()
	private let currentTime = PublishSubject<Double>()
	private var preSeekValue: Double?
	let isSeeking = PublishSubject<Bool>()
	let seekTime = PublishSubject<Double>()
	
	/// Playback
	let play = PublishSubject<DisplayItemModel?>()
	let pause = PublishSubject<Void>()
	let seekValue = PublishSubject<Double>()
	
	init() {
		playingStateObservable = playingState.asObservable().share(replay: 1)
		/// Handle playing request
		_ = play.asObserver()
			.flatMapLatest { [weak self] item -> Observable<URL?> in
				// Play current item if the same item was passed
				// Try to play current item if no item was passed
				if (item == nil) || (item?.id == self?.currentItem?.id) {
//					self?.play()
					return .just(nil)
				}
				guard let itemID = item?.id else { return .just(nil) }
				// Save new item
				self?.currentItem = item
				// Get new item's url
				return 	AppRequest.get(.playmedia,
										  childs: ["media"],
										  placeholders: [.vipd: itemID])
					.map { (result: Result<[MediaModel], RequestError>) -> URL? in
						return try? result.get().first?.connection?.first?.href?.urlEncoded
					}
			}
			.subscribe(onNext: { [weak self] (mediaURL: URL?) in
				self?.play(mediaURL)
			})
		
		/// Handle pause request
		/// Update state and pause player
		_ = pause.asObserver()
			.do(onNext: { [weak self] in self?.player?.pause() })
			.map { [weak self] _ -> String in self?.currentItem?.id ?? "" }
			.map { (id: $0, isPlay: false) }
			.bind(to: playingState)
		
		let seekTimeObservable = seekTime.asObserver().share()
		
		/// Using seekTime + currentTime to update slider + circle progress's value
		let currentTimeObservable = seekTimeObservable.merge(with: self.currentTime.asObserver())
		
		/// Using currentTime value in normaly playing state
		/// Using seekTime value in seeking state
		/// There is only one observable emitting values at a time because we stop update currentTime when user changes slider's value.
		_ = currentTimeObservable.map { Float($0) }.bind(to: playingTrackValue)
		_ = currentTimeObservable.map { $0.asString(style: .positional) }.bind(to: currentTimeString)
		
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
		_ = seekValue.asObserver()
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


extension PlayingViewModel {
	private func play(_ url: URL? = nil) {
		if let url = url {
			// Play new item
			self.prepareToPlay(url: url)
			self.player?.play()
			self.playingState.accept((id: self.currentItem?.id ?? "", isPlay: true))
		} else {
			// Play/Pause current item
			let currentState = self.player?.timeControlStatus
			currentState == .paused ? self.player?.play() : self.player?.pause()
			self.playingState.accept((id: self.currentItem?.id ?? "", isPlay: currentState == .paused))
		}
	}
	
	private func prepareToPlay(url: URL) {
		disposeBag = DisposeBag()
		let playerItem = AVPlayerItem(url: url)
		playerItem.rx.observeWeakly(Int.self, #keyPath(AVPlayerItem.status))
			.subscribe(onNext: { [weak self] status in
				print("☀️ Item State: \(status)")
				if status == 1 {
					self?.duration.accept(playerItem.duration.seconds)
					if let preSeekValue = self?.preSeekValue {
						self?.preSeekValue = nil
						self?.seekTime.onNext(preSeekValue)
					}
				}
			})
			.disposed(by: disposeBag)
		self.player = AVPlayer(playerItem: playerItem)
	}
	
	private func updateItemDetail(_ item: DisplayItemModel?) {
		guard let item = item else { return }
		self.preSeekValue = item.progress?.value
		if item.currentProgress() == 1 {
			self.preSeekValue = nil
		}
		let imageURL = item.imageUrl?.bbc.replace([.recipe: "432x432"]).urlEncoded
		songImage.accept(imageURL)
		songTitle.accept(item.titles?.primary ?? "")
		songDescription.accept("\(item.titles?.secondary ?? "")\n\(item.titles?.tertiary ?? "")")
		duration.accept(self.currentItem?.duration?.value ?? 0)
	}
}



// MARK: - Track player's time
extension PlayingViewModel {
	func addPeriodicTimeObserver() {
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
	
	func removePeriodicTimeObserver() {
		if let timeObserverToken = timeObserverToken {
			player?.removeTimeObserver(timeObserverToken)
			self.timeObserverToken = nil
			print("Remove time observer")
		}
	}
	
	func seek(to time: Double) {
		guard self.player?.status == .readyToPlay else { return }
		self.removePeriodicTimeObserver()
		print("Start seeking to \(time)")
		let seekTime = CMTime(seconds: time, preferredTimescale: 2)
		self.player?.currentItem?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { [weak self] (isFinish) in
			print("Seek to \(time) result: \(isFinish)")
			if isFinish {
				self?.addPeriodicTimeObserver()
			}
		})
	}
}

