//
//  ProgressModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON


class ProgressModel {

    var value : Int = 0
    var label : String = ""

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON) {
		if json.isEmpty {
			return
		}
        value = json["value"].intValue
        label = json["label"].stringValue
	}
}
