//
//  ImpactSmallViewCell.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/2/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit

class ImpactSmallViewCell: UICollectionViewCell {
    
	let coverImageView: UIImageView = {
		let imageview = UIImageView()
		imageview.contentMode = .scaleAspectFill
		return imageview
	}()
	
	let categoryName: UILabel = {
		let label = UILabel()
		label.font = AppDefinition.Font.reithSansMedium.size(15)
		label.textColor = .white
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		addSubview(coverImageView)
		addSubview(categoryName)
		coverImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
		categoryName.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
	
}
