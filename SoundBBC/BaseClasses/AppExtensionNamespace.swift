//
//  AppExtensionNamespace.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/6/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation


struct AppExtensionWrapper<Base> {
	let base: Base
	init(_ base: Base) {
		self.base = base
	}
}


protocol AppExtensionCompatible {}
extension AppExtensionCompatible {
	public var bbc: AppExtensionWrapper<Self> {
		get { return AppExtensionWrapper(self) }
		set {}
	}
	
	public static var bbc: AppExtensionWrapper<Self>.Type {
		get { return AppExtensionWrapper<Self>.self }
		set {}
	}
}

