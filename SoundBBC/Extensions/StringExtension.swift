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
	enum Placeholder: String {
		case recipe = "{recipe}"
		case size = "{size}"
		case type = "{type}"
		case format = "{format}"
	}
	
	func replace(_ placeholders: [Placeholder: String]) -> String {
		var result = base
		placeholders.forEach {
			result = result.replacingOccurrences(of: $0.key.rawValue,
											   with: $0.value)
		}
		return result
	}
}


extension String: AppExtensionCompatible {}
