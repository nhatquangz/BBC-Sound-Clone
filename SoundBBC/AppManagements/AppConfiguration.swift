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
	
	private var config: JSON?
	private var idctaConfig: JSON?
	
	func setup(config: JSON) {
		self.config = config
	}
	
	func setup(idctaConfig: JSON) {
		self.idctaConfig = config
	}
}


// MARK: - APIs
extension AppConfiguration {
	func rmsConfig(_ path: JSONSubscriptType) -> String? {
		return self.config?["rmsConfig"][path].string
	}
	
	func idctaConfig(_ path: [JSONSubscriptType]) -> String? {
		return self.idctaConfig?[path].stringValue
	}
	
	var playbackURL: String {
		guard let baseURL = config?["playbackConfig", "mediaSelectorConfig", "baseUrl"] else {
			return ""
		}
		let mediaSet = "mobile-phone-main"
		return "\(baseURL)/mediaset/\(mediaSet)/vpid/{vpid}/transferformat/hls"
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



