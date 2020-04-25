//
//  AppConfiguration.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

class AppConfiguration {
	
	static let shared = AppConfiguration()
	
	var rmsConfig: JSON?
	
	init() {
		
	}
}
