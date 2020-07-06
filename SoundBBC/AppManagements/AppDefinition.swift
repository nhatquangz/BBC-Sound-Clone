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
		case reithSansBold = "BBCReithSans-Bold"
		
		func size(_ size: CGFloat) -> UIFont {
			return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
		}
	}
	
	
	/**
	Definition of color
	**/
	enum Color {
		static let main = UIColor(hexString: "#1cb955")
		static let preloadProgress = UIColor(hexString: "#F2F2F7")
		static let progressTrack = UIColor(hexString: "#D3D3D3")
	}
	
	
	/**
	Dimensions
	**/
	enum Dimension {
		static let contenPadding: CGFloat = 15
		static let itemSpace: CGFloat = 15
		static let playableItemHeight: CGFloat = 100
		
		// 15: Leading offset
		// 10: Trailing offset
		static let playableItemWidth: CGFloat = UIScreen.main.bounds.width - 15 - 10
		static let dialItemHeight: CGFloat = UIScreen.main.bounds.width / 4
		static let categoryItemHeight: CGFloat = 70
	}
}
