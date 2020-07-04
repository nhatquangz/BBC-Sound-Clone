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
	func configure<T>(data: T)
}
