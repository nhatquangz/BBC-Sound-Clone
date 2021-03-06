//
//  AppEnvironment.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

extension AppEnvironment {
	func value<T>(for key: String) -> T {
		guard let value = Bundle.main.infoDictionary?[key] as? T else {
			fatalError("Invalid or missing Info.plist key: \(key)")
		}
		return value
	}
}

struct AppEnvironment {
	enum Environment: String {
		case development = "development"
		case staging = "staging"
		case product = "production"
	}
	static let shared = AppEnvironment()
	var current: Environment = .development
}
