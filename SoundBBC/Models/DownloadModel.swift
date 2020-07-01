//
//  DownloadModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 6/30/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

class DownloadModel {
	
	var type: String = ""
	var data: [String: DownloadQualityModel] = [:]
	
	init(_ json: JSON) {
		type = json["type"].stringValue
		data = json["quality_variants"].dictionaryValue.mapValues { DownloadQualityModel($0) }
	}
}


// MARK: - Quality
extension DownloadModel {
	class DownloadQualityModel {
		var bitrate: Int?
		var fileSize: Int?
		var fileUrl: String?
		var label: String?

		init(_ json: JSON) {
			bitrate = json["bitrate"].intValue
			fileSize = json["file_size"].intValue
			fileUrl = json["file_url"].stringValue
			label = json["label"].stringValue
		}
	}
}

