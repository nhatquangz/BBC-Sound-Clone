//
//  MediaModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/4/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation

// MARK: - Media
struct MediaModel: Codable {
	let bitrate, service, kind, type: String?
	let encoding: String?
	let expires: String?
	let connection: [ConnectionModel]?
}

// MARK: - Connection
struct ConnectionModel: Codable {
	let priority, connectionProtocol: String?
	let authExpiresOffset: Int?
	let supplier: String?
	let authExpires: String?
	let href: String?
	let transferFormat, dpw: String?

	enum CodingKeys: String, CodingKey {
		case priority
		case connectionProtocol = "protocol"
		case authExpiresOffset, supplier, authExpires, href, transferFormat, dpw
	}
}
