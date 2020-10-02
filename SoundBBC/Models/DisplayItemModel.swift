//
//  DisplayItemModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DisplayItemModel: Decodable {
	
	let type : String?
	let id : String?
	let urn : String?
	let network : NetworkModel?
	let titles : TitleModel?
	let synopses : SynopsisModel?
	let imageUrl : String?
	let duration : KeyValueModel?
	let progress : KeyValueModel?
//	let container : String?
	let download : DownloadModel?
	let availability : AvailabilityModel?
	let release : ReleaseModel?
	let guidance : GuidanceModel?
	let activities : [ActivitiesModel]?
//	let uris : [UrisModel]?
	let playContext : String?
	
	
	struct KeyValueModel: Decodable {
		let label: String?
		let value: Float?
	}
	
	struct TitleModel: Decodable {
		let primary : String?
		let secondary : String?
		let tertiary : String?
	}
	
	struct NetworkModel: Decodable {
		let id : String?
		let key : String?
		let shortTitle : String?
		let logoUrl : String?
	}
	
	
	struct SynopsisModel: Decodable {
		let short : String?
		let medium : String?
		let long : String?
	}
	
	struct AvailabilityModel: Decodable {
		let from : String?
		let to : String?
		let label : String?
	}
	
	struct ReleaseModel: Decodable {
		let date: String?
		let label: String?
	}
	
	
	struct UrisModel: Decodable {
		let type: String?
		let id: String?
		let label: String?
		let uri: String?
	}
	
	struct ActivitiesModel: Decodable {
		let type, action, label: String?
	}
	
	func currentProgress() -> Float? {
		guard let progress = self.progress?.value, let duration = self.duration?.value else { return nil }
		if duration > 0 {
			return progress / duration
		}
		return nil
	}
}
