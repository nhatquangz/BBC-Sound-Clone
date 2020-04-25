//
//  NetworkModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON


class NetworkModel {
	
	var id : String = ""
    var key : String = ""
    var shortTitle : String = ""
    var logoUrl : String = ""

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON ){
		if json.isEmpty {
			return
		}
        id = json["id"].stringValue
        key = json["key"].stringValue
        shortTitle = json["short_title"].stringValue
        logoUrl = json["logo_url"].stringValue
	}
	
}
