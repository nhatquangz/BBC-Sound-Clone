//
//  ReleaseModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate


class ReleaseModel {

    var date : DateInRegion?
    var label : String = ""

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(_ json: JSON) {
		date = json["date"].stringValue.toDate()
        label = json["label"].stringValue
	}
}
