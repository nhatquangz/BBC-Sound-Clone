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
	
	// Player
	private var player: AVPlayer?
	private let currentItem = BehaviorRelay<DisplayItemModel?>(value: nil)
	private let playingState = BehaviorRelay<Bool>(value: false)
	
	init() {
		//		currentItem.asObservable()
		//			.do(onNext: {
		//
		//			})
	}
}


// MARK: - Playable items
extension PlayingViewModel {
	func play(item: DisplayItemModel) {
		guard let itemID = item.id else { return }
		AppRequest.get(.playmedia,
					   childs: ["media"],
					   placeholders: [.vipd: itemID])
			.map { (result: Result<[MediaModel], RequestError>) -> URL? in
				return try? result.get().first?.connection?.first?.href?.urlEncoded
			}
			.subscribe(onNext: { [weak self] (mediaURL: URL?) in
				if let url = mediaURL {
					self?.player = AVPlayer(url: url)
					self?.player?.play()
				}
			})
			.disposed(by: disposeBag)
	}
	
	func pause() {
		self.player?.pause()
	}
}

