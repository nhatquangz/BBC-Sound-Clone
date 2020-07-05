//
//  ProgressLineView.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/5/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class ProgressView: UIView {
	
	enum ProgressViewType {
		case horizontal, circle
	}
	
	private(set) var type: ProgressViewType = .horizontal
	
	private let currentLayer = CAShapeLayer()
	private let preloadLayer = CAShapeLayer()
	private let maskLayer = CAShapeLayer()
	
	private var lineWidth: CGFloat = 15
	private var currentColor = AppDefinition.Color.main
	private var preloadColor = AppDefinition.Color.preloadProgress
	
	private var currentProgress: CGFloat = 0
	private var preloadProgress: CGFloat = 0
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		reloadShape()
	}
	
	private func setup() {
		maskLayer.strokeColor = UIColor.red.cgColor
		maskLayer.fillColor = UIColor.red.cgColor
		maskLayer.lineWidth = lineWidth
		currentLayer.lineWidth = lineWidth
		preloadLayer.lineWidth = lineWidth
		layer.addSublayer(preloadLayer)
		layer.addSublayer(currentLayer)
		layer.mask = maskLayer
	}
	
	private func reloadShape() {
		type == .circle ? drawCircleStyle() : drawHorizontalStyle()
	}
}


// MARK: - Control
extension ProgressView {
	func config(type: ProgressViewType, lineWidth: CGFloat = 5) {
		self.type = type
		self.lineWidth = lineWidth
		reloadShape()
	}
	
	func setProgress(current: CGFloat? = nil, preload: CGFloat? = nil) {
		if let c = current {
			let value = (c > 0 && c < 1) ? c : (c > 1 ? 1 : 0)
			self.currentProgress = value
		}
		if let p = preload {
			let value = (p > 0 && p < 1) ? p : (p > 1 ? 1 : 0)
			self.preloadProgress = value
		}
		reloadShape()
	}
}



// MARK: - Style Progress
extension ProgressView {
	private func drawHorizontalStyle() {
		maskLayer.path = UIBezierPath(rect: self.frame).cgPath
		preloadLayer.frame = CGRect(origin: .zero,
									size: CGSize(width: self.bounds.size.width * preloadProgress,
												 height: self.bounds.size.height))
		preloadLayer.backgroundColor = preloadColor.withAlphaComponent(0.3).cgColor
		
		currentLayer.frame = CGRect(origin: .zero,
									size: CGSize(width: self.bounds.size.width * currentProgress,
												 height: self.bounds.size.height))
		currentLayer.backgroundColor = currentColor.cgColor
	}
	
	private func drawCircleStyle() {
		let d = min(self.frame.width, self.frame.height)
		let circlePath = UIBezierPath(arcCenter: self.center,
									  radius: (d-lineWidth)/2,
									  startAngle: -.pi/2,
									  endAngle: .pi*2,
									  clockwise: true)
		
		maskLayer.fillColor = nil
		maskLayer.path = circlePath.cgPath
		
		currentLayer.path = circlePath.cgPath
		currentLayer.fillColor = nil
		currentLayer.strokeStart = 0
		currentLayer.strokeEnd = currentProgress
		currentLayer.strokeColor = currentColor.cgColor
	}
}



