//
//  PlayableViewCell.swift
//  SoundBBC
//
//  Created by nhatquangz on 6/29/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit

class PlayableViewCell: UICollectionViewCell {
	
	@IBOutlet weak var itemImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = .random
    }
}


extension PlayableViewCell: DisplayableItemView {
	func configure<T>(data: T) {
		guard let data = data as? DisplayItemModel else { return }
		let imageURL = data.imageUrl.replacingOccurrences(of: "{recipe}", with: "192x192").urlEncoded
		itemImageView.kf.setImage(with: imageURL)
		titleLabel.text = data.titles?.primary ?? ""
		descriptionLabel.text = "\(data.titles?.secondary ?? "")\n\(data.titles?.tertiary ?? "")"
	}
}

