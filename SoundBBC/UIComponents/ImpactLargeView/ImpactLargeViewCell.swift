//
//  ImpactLargeViewCell.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/2/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit
import Kingfisher

class ImpactLargeViewCell: UICollectionViewCell {

	@IBOutlet weak var coverImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
		backgroundColor = .random
    }
}

extension ImpactLargeViewCell: DisplayableItemView {
	func configure<T>(data: T) {
		guard let data = data as? DisplayItemModel else { return }
		// 736x736 - 432x432 - 192x192
		let imageURL = data.imageUrl.replacingOccurrences(of: "{recipe}", with: "432x432").urlEncoded
		coverImageView.kf.setImage(with: imageURL)
		titleLabel.text = data.titles?.primary ?? ""
		descriptionLabel.text = data.synopses?.shortField ?? ""
	}
}

