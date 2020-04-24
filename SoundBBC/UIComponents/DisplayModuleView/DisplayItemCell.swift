//
//  DisplayItemCell.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit

class DisplayItemCell: UICollectionViewCell {
	
	var displayItem: DisplayableItemView?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func attach(content: DisplayableItemView) {
		if let view = content as? UIView {
			addSubview(view)
			view.snp.makeConstraints { (maker) in
				maker.edges.equalToSuperview()
			}
		}
	}
	
	func configure(data: DisplayableItemData, type itemType: DisplayableItemType) {
		if displayItem == nil {
			self.attach(content: itemType.instance())
		}
		displayItem?.configure(data: data)
	}
}
