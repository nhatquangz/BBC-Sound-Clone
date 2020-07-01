//
//  UrisModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 6/30/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

class UrisModel {
	
	var id : String = ""
    var label : String = ""
    var type : String = ""
    var uri : String = ""

	init(_ json: JSON) {
		id = json["id"].stringValue
        label = json["label"].stringValue
        type = json["type"].stringValue
        uri = json["uri"].stringValue
	}
}
