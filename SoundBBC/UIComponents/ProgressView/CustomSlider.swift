//
//  CustomSlider.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/2/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
	
	override func trackRect(forBounds bounds: CGRect) -> CGRect {
		var newBounds = super.trackRect(forBounds: bounds)
		newBounds.size.height = 5
		newBounds.origin.x = 0
		return newBounds
	}
	
}
