//
//  StringExtension.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/4/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit

extension String {
	var urlEncoded: URL? {
		let encoded = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
		return URL(string: encoded)
	}
}


// MARK: - Replace Image URL
extension AppExtensionWrapper where Base == String {
	func recipe(_ size: String) -> String {
		base.replacingOccurrences(of: "{recipe}", with: size)
	}
}


extension String: AppExtensionCompatible {}
