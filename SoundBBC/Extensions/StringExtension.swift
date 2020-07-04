//
//  StringExtension.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/4/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation

extension String {
	var urlEncoded: URL? {
		let encoded = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
		return URL(string: encoded)
	}
}
