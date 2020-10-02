//
//  DownloadModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 6/30/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation

struct DownloadModel: Decodable {
	let type: String?
	let qualityVariants: QualityVariants?

	enum CodingKeys: String, CodingKey {
		case type
		case qualityVariants = "quality_variants"
	}
}

// MARK: - QualityVariants
struct QualityVariants: Decodable {
	let low, medium, high: Quality?
	
	struct Quality: Decodable {
		let bitrate: Int?
		let fileurl: String?
		let fileSize: Int?
		let label: String?

		enum CodingKeys: String, CodingKey {
			case bitrate
			case fileurl = "file_url"
			case fileSize = "file_size"
			case label
		}
	}
}

