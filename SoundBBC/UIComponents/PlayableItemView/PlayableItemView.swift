//
//  PlayableItemView.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit

class PlayableItemView: UIView {
	
	let nibName = "PlayableItemView"
	@IBOutlet weak var contentView: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
	}
}
