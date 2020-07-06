//
//  DisplayModuleModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

class DisplayModuleModel: DecodableModelProtocol {
	var type : String = ""
    var id : String = ""
    var style : String = ""
    var title : String = ""
    var descriptionField : String = ""
    var state : String = ""
    var uris : [UrisModel] = []
    var controls: ControlsModel?
    var total : Int = 0
    var data : [DisplayItemModel] = []

	required init(_ json: JSON) {
        type = json["type"].stringValue
        id = json["id"].stringValue
		style = json["style"].stringValue
        title = json["title"].stringValue
        descriptionField = json["description"].stringValue
        state = json["state"].stringValue
		uris = json["uris"].arrayValue.compactMap { UrisModel($0) }
        total = json["total"].intValue
		data = json["data"].arrayValue.compactMap { DisplayItemModel($0) }
		if !json["controls"].isEmpty {
			controls = ControlsModel(json["controls"])
		}
	}
}

// MARK: - Hashable
extension DisplayModuleModel: Hashable {
	static func == (lhs: DisplayModuleModel, rhs: DisplayModuleModel) -> Bool {
		return lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
	  hasher.combine(id)
	}
}

