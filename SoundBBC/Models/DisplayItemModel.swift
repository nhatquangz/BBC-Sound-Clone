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
    var duration: KeyValueModel?
    var progress: KeyValueModel?
    var container: String = ""
    var download: String = ""
    var availability: AvailabilityModel?
    var release: ReleaseModel?
    var guidance: String = ""
    var activities: [String] = []
    var uris: [UrisModel] = []
    var playContext: String = ""
	
	
	class KeyValueModel {
		var label: String = ""
		var value: Int?
		init(_ json: JSON){
			if json.isEmpty {
				return
			}
			label = json["label"].stringValue
			value = json["value"].intValue
		}
	}
	
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(_ json: JSON) {
        type = json["type"].stringValue
        id = json["id"].stringValue
        urn = json["urn"].stringValue
        network = NetworkModel(json["network"])
        titles = TitleModel(json["titles"])
        synopses = SynopsisModel(json["synopses"])
        imageUrl = json["image_url"].stringValue
        duration = KeyValueModel(json["duration"])
        progress = KeyValueModel(json["progress"])
		container = json["container"].stringValue
		download = json["download"].stringValue
        availability = AvailabilityModel(json["availability"])
        release = ReleaseModel(json["release"])
		guidance = json["guidance"].stringValue
        activities = json["activities"].arrayValue.compactMap { $0.stringValue }
        uris = json["uris"].arrayValue.compactMap { UrisModel($0) }
		playContext = json["play_context"].stringValue
	}
}

// MARK: - Hashable
extension DisplayItemModel: Hashable {
	static func == (lhs: DisplayItemModel, rhs: DisplayItemModel) -> Bool {
		return lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
	  hasher.combine(id)
	}
}

