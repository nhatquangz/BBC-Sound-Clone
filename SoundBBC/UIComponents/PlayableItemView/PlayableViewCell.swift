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
	@IBOutlet weak var progressBar: ProgressView!
	@IBOutlet weak var timeLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = .random
		progressBar.config(type: .horizontal)
    }
}


extension PlayableViewCell: DisplayableItemView {
	func configure<T>(data: T) {
		let data = data as? DisplayItemModel
		let imageURL = data?.imageUrl.bbc.replace([.recipe: "192x192"]).urlEncoded
		itemImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.4))])
		titleLabel.text = data?.titles?.primary ?? ""
		descriptionLabel.text = "\(data?.titles?.secondary ?? "")\n\(data?.titles?.tertiary ?? "")"
		
		if let progress = data?.currentProgress() {
			timeLabel.text = data?.progress?.label ?? ""
			progressBar.isHidden = false
			progressBar.setProgress(current: CGFloat(progress))
		} else {
			timeLabel.text = data?.duration?.label ?? ""
			progressBar.isHidden = true
		}
	}
}

