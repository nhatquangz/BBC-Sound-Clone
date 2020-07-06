//
//  CircleViewCell.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/3/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CircleViewCell: UICollectionViewCell {
	
	let coverImageView: UIImageView = {
		let imageview = UIImageView()
		imageview.clipsToBounds = true
		imageview.contentMode = .scaleAspectFill
		return imageview
	}()
	
	let channelImageView: UIImageView = {
		let imageview = UIImageView()
		imageview.clipsToBounds = true
		imageview.contentMode = .scaleAspectFill
		return imageview
	}()
	
	let progressView = ProgressView(.circle, lineWidth: 4)
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		let itemRadius = AppDefinition.Dimension.dialItemHeight / 2
		self.clipsToBounds = false
		self.backgroundColor = .random
		self.layer.cornerRadius = itemRadius
		self.coverImageView.layer.cornerRadius = itemRadius
		
		contentView.addSubview(coverImageView)
		contentView.addSubview(progressView)
		contentView.addSubview(channelImageView)
		
		coverImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
		progressView.snp.makeConstraints { $0.edges.equalToSuperview() }
		channelImageView.snp.makeConstraints {
			$0.width.height.equalTo(itemRadius * 0.7)
			$0.right.equalToSuperview()
			$0.bottom.equalToSuperview().inset(8)
		}
	}
}


extension CircleViewCell: DisplayableItemView {
	func configure<T>(data: T) {
		let data = data as? DisplayItemModel
		let imageURL = data?.imageUrl.bbc.replace([.recipe: "320x180"]).urlEncoded
		coverImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.4))])
		let logoURL = data?.network?.logoUrl.bbc.replace([.type: "colour",
														  .size: "276",
														  .format: "png"]).urlEncoded
		channelImageView.kf.setImage(with: logoURL, options: [.transition(.fade(0.4))])
		if let progress = data?.currentProgress() {
			self.progressView.setProgress(current: CGFloat(progress))
		} else {
			self.progressView.setProgress(current: 0, preload: 0)
		}
	}
}

