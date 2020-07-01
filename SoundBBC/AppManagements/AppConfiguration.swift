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
	
	var config: JSON?
	
	func setup(config: JSON) {
		self.config = config
	}
}

// MARK: - APIs
extension AppConfiguration {
	func rmsConfig(path: String) -> String? {
		return self.config?["rmsConfig"][path].string
	}
}

// MARK: - Theme
extension AppConfiguration {
	func theme(id: String) -> LayoutProvider.AppElementTheme {
		if let raw = config?["rmsConfig"]["themes"][id].stringValue, let theme = LayoutProvider.AppElementTheme(rawValue: raw) {
			return theme
		}
		return .unknown
	}
}



