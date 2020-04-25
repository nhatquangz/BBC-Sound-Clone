//
//  DisplayModuleModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

class DisplayModuleModel {
	var type : String = ""
    var id : String = ""
    var style : String = ""
    var title : String = ""
    var descriptionField : String = ""
    var state : String = ""
    var uris : String = ""
    var controls : String = ""
    var total : Int = 0
    var data : [DisplayItemModel] = []

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON) {
		if json.isEmpty {
			return
		}
        type = json["type"].stringValue
        id = json["id"].stringValue
		style = json["style"].stringValue
        title = json["title"].stringValue
        descriptionField = json["description"].stringValue
        state = json["state"].stringValue
		uris = json["uris"].stringValue
		controls = json["controls"].stringValue
        total = json["total"].intValue
		data = json["data"].arrayValue.compactMap { DisplayItemModel(fromJson: $0) }

	}

}

