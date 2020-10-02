//
//  ControlsModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/2/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ControlsModel: Decodable {
	let sorting: SortingModel?
	let navigation: Navigation?
	
	
	struct Navigation: Decodable {
		let type: String?
		let id: String?
		let urn: String?
		let style: String?
		let title: String?
		let target: Target?
	}
	
	
	struct Target: Decodable {
		let urn: String?
		let uri: String?
	}
	
	
	struct SortingModel: Decodable {
		let type: String?
		let id: String?
		let urn: String?
		let style: String?
		let title: String?
		let data: [SelectionModel]?
	}
	
	
	struct SelectionModel: Decodable {
		let type: String?
		let id: String?
		let urn: String?
		let label: String?
		let selected: Bool?
	}
	
}
