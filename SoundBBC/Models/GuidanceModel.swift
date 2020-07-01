//
//  GuidanceModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 6/30/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

class GuidanceModel {
	
	var competitionWarning : Bool = false
	var warnings : WarningModel?
	
	init(_ json: JSON) {
		competitionWarning = json["competition_warning"].boolValue
		warnings = WarningModel(json["warnings"])
	}
}

// MARK: - Warning
extension GuidanceModel {
	class WarningModel {
		var longField : String = ""
		var shortField : String = ""
		init(_ json: JSON) {
			longField = json["long"].stringValue
			shortField = json["short"].stringValue
		}
	}
}

