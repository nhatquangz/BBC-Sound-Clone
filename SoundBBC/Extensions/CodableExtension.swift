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
	func decodedArray<T: Decodable>() -> [T] {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		do {
			return try decoder.decode([T].self, from: self)
		} catch {
			print(error)
			return []
		}
//		return (try? decoder.decode([T].self, from: self)) ?? []
	}
	
	func decoded<T: Decodable>() throws -> T {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode(T.self, from: self)
	}
}
