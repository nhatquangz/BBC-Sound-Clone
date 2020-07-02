//
//  AppDefinition.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit

class AppDefinition: NSObject {
	/**
	Custom font
	**/
	enum Font: String {
		case reithSerif = "BBCReithSerif-Regular"
		case reithSans = "BBCReithSans-Regular"
		case reithSerifMedium = "BBCReithSerif-Medium"
		case reithSansMedium = "BBCReithSans-Medium"
		
		func size(_ size: CGFloat) -> UIFont {
			return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
		}
	}
	
	
	/**
	Definition of color
	**/
	enum Color {
		static var main = UIColor(hexString: "#1cb955")
	}
	
	
	/**
	Dimensions
	**/
	enum Dimension {
		static var contentPadding: CGFloat = 15
		static var itemSpace: CGFloat = 10
		static var playableItemHeight: CGFloat = 100
		
		// 15: Leading offset
		// 7.5: Trailing offset
		static var playableItemWidth: CGFloat = UIScreen.main.bounds.width - 15 - 10
	}
}
