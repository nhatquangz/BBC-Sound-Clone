//
//  Number+Extension.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/5/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation

extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
	let formatter = DateComponentsFormatter()
	if self > 60 * 60 {
		formatter.allowedUnits = [.hour, .minute, .second]
	} else {
		formatter.allowedUnits = [.minute, .second]
	}
	formatter.zeroFormattingBehavior = .pad
	formatter.unitsStyle = style
	guard let formattedString = formatter.string(from: TimeInterval(self)) else { return "" }
	return formattedString
  }
}
