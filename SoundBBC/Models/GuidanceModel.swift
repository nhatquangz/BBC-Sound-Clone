//
//  GuidanceModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 6/30/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Guidance
struct GuidanceModel: Decodable {
	
	let competitionWarning: Bool?
	let warnings: Warnings?

	enum CodingKeys: String, CodingKey {
		case competitionWarning = "competition_warning"
		case warnings
	}
}

// MARK: - Warnings
struct Warnings: Codable {
	let short, long: String?
}

