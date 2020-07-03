//
//  CircleViewCell.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/3/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit

class CircleViewCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		self.backgroundColor = .random
		self.layer.cornerRadius = AppDefinition.Dimension.dialItemHeight / 2
	}
}
