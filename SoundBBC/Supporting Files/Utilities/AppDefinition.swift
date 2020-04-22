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
	
	enum Font: String {
		case reithSerif = "BBCReithSerif-Regular"
		case reithSans = "BBCReithSans-Regular"
		case reithSerifMedium = "BBCReithSerif-Medium"
		case reithSansMedium = "BBCReithSans-Medium"
		
		func size(_ size: CGFloat) -> UIFont {
			return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
		}
	}
	
}
