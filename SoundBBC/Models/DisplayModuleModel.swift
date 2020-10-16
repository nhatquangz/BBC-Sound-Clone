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
//	let controls : String?
	let total : Int?
	let data : [DisplayItemModel]?
	
	enum CodingKeys: String, CodingKey {
		case type = "type"
		case id = "id"
		case style = "style"
		case title = "title"
		case descriptionField = "description"
		case data = "data"
		case state = "state"
//		case uris = "uris"
//		case controls = "controls"
		case total = "total"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		style = try values.decodeIfPresent(String.self, forKey: .style)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
		data = try? values.decodeIfPresent([DisplayItemModel].self, forKey: .data) ?? nil
		state = try values.decodeIfPresent(String.self, forKey: .state)
//		controls = try values.decodeIfPresent(String.self, forKey: .controls)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
	}
}

