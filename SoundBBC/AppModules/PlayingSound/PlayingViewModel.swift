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
	
	let position = BehaviorRelay<PlayingViewPosition>(value: .hide)
	
	typealias PlayingState = (id: String, isPlay: Bool)
	let playingState = BehaviorRelay<PlayingState>(value: (id: "", isPlay: false))
	
	// Player
	private var player: AVPlayer?
	private var currentItem: DisplayItemModel?
	
	/// Control
	let play = PublishSubject<DisplayItemModel>()
	let pause = PublishSubject<Void>()
	
	
	init() {
		/// Handle playing request
		play.asObserver()
			.flatMapLatest { [weak self] item -> Observable<URL?> in
				guard let itemID = item.id else { return .just(nil) }
				// Play the same item
				if itemID == self?.currentItem?.id {
					self?.player?.play()
					return .just(nil)
				}
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
					self?.play(url: url)
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
	private func play(url: URL) {
		self.player = AVPlayer(url: url)
		self.player?.play()
		self.playingState.accept((id: self.currentItem?.id ?? "", isPlay: true))
	}
}

