//
//  ImpactLargeViewCell.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/2/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class ImpactLargeViewCell: UICollectionViewCell {

	@IBOutlet weak var coverImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	var viewModel: ListenCellViewModel?
	var disposeBag = DisposeBag()
	
    override func awakeFromNib() {
        super.awakeFromNib()

    }
	
	override func prepareForReuse() {
		disposeBag = DisposeBag()
		super.prepareForReuse()
	}
}

extension ImpactLargeViewCell: DisplayableItemView {
	func configure<T>(data: T) {
		viewModel = data as? ListenCellViewModel
		// 736x736 - 432x432 - 192x192 - 320x180
		let imageURL = viewModel?.imageURL(placeholders: [.recipe: "432x432"])
		coverImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.4))])
		viewModel?.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
		viewModel?.synopses.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
	}
}

