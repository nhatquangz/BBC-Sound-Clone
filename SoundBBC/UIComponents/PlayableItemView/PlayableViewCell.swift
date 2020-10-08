//
//  PlayableViewCell.swift
//  SoundBBC
//
//  Created by nhatquangz on 6/29/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PlayableViewCell: UICollectionViewCell {
	
	@IBOutlet weak var itemImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var timeLabel: UILabel!
	
	@IBOutlet weak var playButton: UIButton!
	
	
	var viewModel: ListenCellViewModel?
	var disposeBag = DisposeBag()
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = .random
		progressBar.transform = CGAffineTransform.init(scaleX: 1, y: 3.2)
		progressBar.progressTintColor = AppConstants.Color.main
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = DisposeBag()
	}
}


extension PlayableViewCell: DisplayableItemView {
	func configure<T>(data: T) {
		guard let viewModel = data as? ListenCellViewModel else { return }
		self.viewModel = viewModel
		let imageURL = viewModel.imageURL(placeholders: [.recipe: "192x192"])
		itemImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.4))])
		
		viewModel.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
		
		viewModel.descriptionText.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
		
		viewModel.showProgressBar
			.map { !$0 }
			.bind(to: progressBar.rx.isHidden)
			.disposed(by: disposeBag)
		
		viewModel.currentProgress
			.bind(to: progressBar.rx.progress)
			.disposed(by: disposeBag)
		
		viewModel.dateTimeText
			.bind(to: timeLabel.rx.text)
			.disposed(by: disposeBag)
		
		viewModel.playingState.distinctUntilChanged()
			.bind(to: playButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		playButton.rx.tap.asObservable()
			.throttle(.seconds(1), scheduler: MainScheduler.instance)
			.bind(to: viewModel.playItem)
			.disposed(by: disposeBag)
	}
}

