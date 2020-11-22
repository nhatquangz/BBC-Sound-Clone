//
//  CodableExtension.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/1/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation

extension Encodable {
	func encoded() throws -> Data {
		return try JSONEncoder().encode(self)
	}
}

extension Data {
	func decoded<T: Decodable>() throws -> T {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode(T.self, from: self)
	}
}
