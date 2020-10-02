//
//  DisplayModuleModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DisplayModuleModel: Decodable {
	
	let type : String?
	let id : String?
	let style : String?
	let title : String?
	let descriptionField : String?
	let state : String?
//	let uris : String?
	let controls : String?
	let total : Int?
	let data : [DisplayItemModel]?
	
}

