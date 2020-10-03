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
		 let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
		 super.trackRect(forBounds: customBounds)
		return customBounds
	}
	
}

class LineProgress: UISlider {
	override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
		return .zero
	}
}
