//
//  DisplayItemModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

class DisplayItemModel {
	var type: String = ""
    var id: String = ""
    var urn: String = ""
    var network: NetworkModel?
    var titles: TitleModel?
    var synopses: SynopsisModel?
    var imageUrl: String = ""
    var duration: DurationModel?
    var progress: ProgressModel?
    var container: String = ""
    var download: String = ""
    var availability: AvailabilityModel?
    var release: ReleaseModel?
    var guidance: String = ""
    var activities: [String] = []
    var uris: [String] = []
    var playContext: String = ""

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON) {
		if json.isEmpty {
			return
		}
        type = json["type"].stringValue
        id = json["id"].stringValue
        urn = json["urn"].stringValue
        network = NetworkModel(fromJson: json["network"])
        titles = TitleModel(fromJson: json["titles"])
        synopses = SynopsisModel(fromJson: json["synopses"])
        imageUrl = json["image_url"].stringValue
        duration = DurationModel(fromJson: json["duration"])
        progress = ProgressModel(fromJson: json["progress"])
		container = json["container"].stringValue
		download = json["download"].stringValue
        availability = AvailabilityModel(fromJson: json["availability"])
        release = ReleaseModel(fromJson: json["release"])
		guidance = json["guidance"].stringValue
        activities = json["activities"].arrayValue.compactMap { $0.stringValue }
        uris = json["uris"].arrayValue.compactMap { $0.stringValue }
		playContext = json["play_context"].stringValue
	}
}

// MARK: - Displayable item
extension DisplayItemModel: DisplayableItemData {
	
}

