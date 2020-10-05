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
	let disposeBag = DisposeBag()
	
	/// UI output
	let songImage = BehaviorRelay<URL?>(value: nil)
	let songTitle = BehaviorRelay<String>(value: "")
	let songDescription = BehaviorRelay<String>(value: "")
	
	
	////
	let changePosition = PublishSubject<PlayingViewPosition>()
	let position = BehaviorRelay<PlayingViewPosition>(value: .hide)
	
	// Observer state of playingview
	typealias PlayingState = (id: String, isPlay: Bool)
	private let playingState = BehaviorRelay<PlayingState>(value: (id: "", isPlay: false))
	let playingStateObservable: Observable<PlayingState>
	
	// Player
	private var player: AVPlayer?
	private var currentItem: DisplayItemModel? {
		didSet {
			self.updateItemDetail(currentItem)
		}
	}
	
	/// Control
	let play = PublishSubject<DisplayItemModel?>()
	let pause = PublishSubject<Void>()
	
	
	init() {
		playingStateObservable = playingState.asObservable().share()
		
		/// Handle playing request
		play.asObserver()
			.flatMapLatest { [weak self] item -> Observable<URL?> in
				// Play current item if the same item passed
				// Try to play current item if no item passed
				if (item == nil) || (item?.id == self?.currentItem?.id) {
					self?.play()
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
				if let url = mediaURL {
					self?.play(url)
				}
			})
			.disposed(by: disposeBag)
		
		
		/// Handle pause request
		pause.asObserver()
			.do(onNext: { [weak self] in self?.player?.pause() })
			.map { [weak self] _ -> String in self?.currentItem?.id ?? "" }
			.map { (id: $0, isPlay: false) }
			.bind(to: playingState)
			.disposed(by: disposeBag)
		
	}
}


// MARK: - Control
extension PlayingViewModel {
	private func play(_ url: URL? = nil) {
		if let url = url {
			self.player = AVPlayer(url: url)
			self.player?.play()
			self.playingState.accept((id: self.currentItem?.id ?? "", isPlay: true))
		} else {
			let currentState = self.player?.timeControlStatus
			currentState == .paused ? self.player?.play() : self.player?.pause()
			self.playingState.accept((id: self.currentItem?.id ?? "", isPlay: currentState == .paused))
		}
	}
	
	private func updateItemDetail(_ item: DisplayItemModel?) {
		guard let item = item else { return }
		let imageURL = item.imageUrl?.bbc.replace([.recipe: "432x432"]).urlEncoded
		songImage.accept(imageURL)
		songTitle.accept(item.titles?.primary ?? "")
		songDescription.accept("\(item.titles?.secondary ?? "")\n\(item.titles?.tertiary ?? "")")
	}
}

