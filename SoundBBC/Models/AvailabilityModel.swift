//
//  AvailabilityModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON


class AvailabilityModel {

    var from : String = ""
    var to : String = ""
    var label : String = ""

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(_ json: JSON) {
		from = json["from"].stringValue
		to = json["to"].stringValue
        label = json["label"].stringValue
	}
}
