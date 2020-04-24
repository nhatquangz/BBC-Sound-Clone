//
//  DisplayModuleDataSource.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit


protocol DisplayModuleData {
	var title: String { get set }
	var items: [DisplayableItemData] { get set }
}

class DisplayModule: DisplayModuleData {
	var title = "Continue Listening"
	var items: [DisplayableItemData] = (1...10).map { _ in DisplayItemModel() }
}
