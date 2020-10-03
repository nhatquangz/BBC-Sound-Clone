//
//  TransparentGradientView.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/2/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TransparentGradientView: UIView {
	
	let gradient = CAGradientLayer()
	
	@IBInspectable
	var distance: Float = 0.05 {
		didSet {
			gradient.locations = [0, distance as NSNumber, (1-distance) as NSNumber, 1]
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override func layoutSubviews() {
		gradient.frame = self.bounds
	}
	
	private func setup() {
		gradient.frame = self.bounds
		gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
		gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradient.endPoint = CGPoint(x: 1, y: 0.5)
		self.layer.mask = gradient
	}
}
