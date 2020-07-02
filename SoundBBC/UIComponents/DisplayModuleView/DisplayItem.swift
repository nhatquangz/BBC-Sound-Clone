//
//  DisplayItem.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit

protocol DisplayableItemView {
	func configure(data: DisplayableItemData)
}

protocol DisplayableItemData {
	
}


enum DisplayableItemType {
	case playable
	case container
	case category
}
