//
//  SinglePromotionCell.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/8/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SinglePromotionCell: UICollectionViewCell {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var gradientView: TransparentGradientView!
	
	@IBOutlet weak var tertiaryLabel: UILabel!
	@IBOutlet weak var primaryLabel: UILabel!
	@IBOutlet weak var secondaryLabel: UILabel!
	
	var viewModel: ListenCellViewModel?
	var disposeBag = DisposeBag()
	
    override func awakeFromNib() {
        super.awakeFromNib()
		gradientView.gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
		gradientView.gradient.startPoint = CGPoint(x: 0.5, y: 1)
		gradientView.gradient.endPoint = CGPoint(x: 0.5, y: 0)
    }
	
	override func prepareForReuse() {
		disposeBag = DisposeBag()
		super.prepareForReuse()
	}
}

extension SinglePromotionCell: DisplayableItemView {
	func configure<T>(data: T) {
		viewModel = data as? ListenCellViewModel
		// 736x736 - 432x432 - 192x192 - 320x180 - 672x378
		// 320x180 - 256x144
		let imageURL = viewModel?.imageURL(placeholders: [.recipe: "672x378"])
		imageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.4))])
		viewModel?.title.bind(to: primaryLabel.rx.text).disposed(by: disposeBag)
		viewModel?.secondaryTitle.bind(to: secondaryLabel.rx.text).disposed(by: disposeBag)
		viewModel?.tertiaryTitle.bind(to: tertiaryLabel.rx.text).disposed(by: disposeBag)
	}
}
