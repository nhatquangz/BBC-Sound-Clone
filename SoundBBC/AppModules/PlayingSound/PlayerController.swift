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
import MediaPlayer



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
	let playActions = PublishSubject<PlayActions>()

	
	init() {
		setupMediaPlayerNotificationView()
		let seekTimeObservable = seekTime.asObservable().share()
		/// Using seekTime + currentTime to update slider + circle progress's value
		/// Using currentTime value in normaly playing state
		/// Using seekTime value in seeking state
		/// There is only one observable emitting values at a time because we stop update currentTime when there are seeking events
		let currentTimeObservable = seekTimeObservable.merge(with: self.currentTime.asObservable())
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
		_ = rewindAmount.asObservable()
			/// User is seeking, stop updating current time
			.do(onNext: { [weak self] _ in self?.removePeriodicTimeObserver() })
			/// Calculate target value to seek
			.withLatestFrom(self.currentTime.asObservable()) { [weak self] (seekValue, currentTime) -> Double in
				guard let self = self else { return 0 }
				let duration = self.duration.value
				var targetTime = currentTime + seekValue
				if targetTime < 0 { targetTime = 0 }
				if targetTime > duration { targetTime = duration }
				return targetTime
			}
			.bind(to: seekTime, currentTime)
		
		/// Update play actions
		_ = self.currentTime.asObservable()
			.throttle(.seconds(60), scheduler: MainScheduler.instance)
			.map { PlayActions.heartbeat(elapsedTime: $0) }
			.bind(to: playActions)
		
		_ = self.playingState.asObservable()
			.map { [weak self] item -> PlayActions in
				let elapsedTime = self?.player?.currentTime().seconds ?? 0
				return item.isPlay ? PlayActions.started(elapsedTime: elapsedTime) :
					PlayActions.paused(elapsedTime: elapsedTime)
				
			}
			.bind(to: playActions)
		
		/// Notification playing view update
		_ = duration.asObservable().subscribe(onNext: { [weak self] value in
			self?.updateNowPlaying()
		})
		_ = timeObservable.asObservable().subscribe(onNext: { [weak self] value in
			self?.updateNowPlaying()
		})
		
		/// Handle interruption
		_ = NotificationCenter.default.rx.notification(AVAudioSession.interruptionNotification)
			.subscribe(onNext: { [weak self] notification in
				guard let userInfo = notification.userInfo,
					  let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
					  let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
					return
				}
				if type == .began {
					print("Interruption began")
					self?.pause()
				}
			})
		
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
		/// If the same item was passed, play current item if need be
		guard itemID != currentItemID else {
			if shouldPlay { self.play() }
			return
		}
		self.currentItemID = itemID
		self.preSeekValue = seekTime
		// Get new item's url
		AppRequest.request(.playmedia,
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
		self.playingState.accept((id: currentItemID, isPlay: false))
		player.pause()
	}
	
	/// Play current item if any
	func play() {
		guard let player = self.player else { return }
		self.playingState.accept((id: currentItemID, isPlay: true))
		player.play()
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
				print("☀️ Item State: \(String(describing: status))")
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
		} else {
			self.pause()
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
				/// Update play actions after seeking
				let currentTime = self?.player?.currentTime().seconds ?? 0
				let action: PlayActions = isPlay ? .started(elapsedTime: currentTime) : .paused(elapsedTime: currentTime)
				self?.playActions.onNext(action)
			}
		})
	}
}


// MARK: - Play actions
extension PlayerController {
	enum PlayActions {
		case started(elapsedTime: Double)
		case paused(elapsedTime: Double)
		case heartbeat(elapsedTime: Double)
		
		var key: String {
			switch self {
			case .started(_): return "started"
			case .heartbeat(_): return "heartbeat"
			case .paused(_): return "paused"
			}
		}
		
		var value: Double {
			switch self {
			case .started(elapsedTime: let elapsedTime):
				return elapsedTime
			case .paused(elapsedTime: let elapsedTime):
				return elapsedTime
			case .heartbeat(elapsedTime: let elapsedTime):
				return elapsedTime
			}
		}
	}
}


// MARK: - Notification display
extension PlayerController {
	private func setupMediaPlayerNotificationView() {
		// Get the shared MPRemoteCommandCenter
		let commandCenter = MPRemoteCommandCenter.shared()
		commandCenter.togglePlayPauseCommand.addTarget { [unowned self] event in
			self.changePlayerState()
			return .success
		}
		// Seek
		commandCenter.skipForwardCommand.preferredIntervals = [20]
		commandCenter.skipForwardCommand.addTarget { [unowned self] (event) in
			self.rewindAmount.onNext(20)
			return .success
		}
		commandCenter.skipBackwardCommand.preferredIntervals = [20]
		commandCenter.skipBackwardCommand.addTarget { [unowned self] (event) in
			self.rewindAmount.onNext(-20)
			return .success
		}

		commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] (event) in
			if let event = event as? MPChangePlaybackPositionCommandEvent {
				self.seek(to: event.positionTime)
				return .success
			}
			return .commandFailed
		}
	}
	
	private func updateNowPlaying() {
		guard var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo else { return }
		nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime().seconds
		nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.currentItem?.duration.seconds
		nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
		// Set the metadata
		MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
	}
	
	func setupNowPlaying(title: String, description: String = "", image: UIImage? = nil) {
		var nowPlayingInfo = [String : Any]()
		nowPlayingInfo[MPMediaItemPropertyTitle] = title
		nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = description.trimmingCharacters(in: .whitespacesAndNewlines)
		if let image = image {
			nowPlayingInfo[MPMediaItemPropertyArtwork] =
				MPMediaItemArtwork(boundsSize: image.size) { size in
					return image
				}
		}
		nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
		// Set the metadata
		MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
	}
}
