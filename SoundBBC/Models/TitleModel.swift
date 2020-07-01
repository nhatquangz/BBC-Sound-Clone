//
//  TitleModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON


class TitleModel {

	var primary: String = ""
	var secondary: String = ""
	var tertiary: String = ""

	init(_ json: JSON) {
		primary = json["primary"].stringValue
		secondary = json["secondary"].stringValue
		tertiary = json["tertiary"].stringValue
	}
}
