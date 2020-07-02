//
//  ControlsModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/2/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

class ControlsModel {
	
	var sorting: SortingModel?
	var navigation: Navigation?
	
	init(_ json: JSON) {
		sorting = SortingModel(json["sorting"])
		navigation = Navigation(json["navigation"])
	}
}


class Navigation {
	var type: String = ""
	var id: String = ""
	var urn: String = ""
	var style: String = ""
	var title: String = ""
	var target: Target?
	init(_ json: JSON) {
		type = json["type"].stringValue
		id = json["id"].stringValue
		urn = json["urn"].stringValue
		style = json["style"].stringValue
		title = json["title"].stringValue
		target = Target(json["target"])
	}
}


class Target {
	var urn: String = ""
	var uri: String = ""
	init(_ json: JSON) {
		urn = json["urn"].stringValue
		uri = json["uri"].stringValue
	}
}


class SortingModel {
	var type: String = ""
	var id: String = ""
	var urn: String = ""
	var style: String = ""
	var title: String = ""
	var data: [SelectionModel] = []
	
	init(_ json: JSON) {
		type = json["type"].stringValue
		id = json["id"].stringValue
		urn = json["urn"].stringValue
		style = json["style"].stringValue
		title = json["title"].stringValue
		data = json["data"].arrayValue.map { SelectionModel($0) }
	}
}


class SelectionModel {
	
	var type: String = ""
	var id: String = ""
	var urn: String = ""
	var label: String = ""
	var selected: Bool = false
	
	init(_ json: JSON) {
		type = json["type"].stringValue
		id = json["id"].stringValue
		urn = json["urn"].stringValue
		label = json["label"].stringValue
		selected = json["selected"].boolValue
	}
}
