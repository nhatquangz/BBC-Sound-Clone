//
//  RxExtension.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/3/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: CircleProgressView {
	var progress: Binder<CGFloat> {
		return Binder(self.base) { view, progress in
			view.setProgress(current: progress)
		}
	}
}
