//
//  SynopsisModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON


class SynopsisModel {

    var shortField : String = ""
    var medium : String = ""
    var longField : String = ""

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON) {
		if json.isEmpty {
			return
		}
        shortField = json["short"].stringValue
        medium = json["medium"].stringValue
		longField = json["long"].stringValue
	}
}
