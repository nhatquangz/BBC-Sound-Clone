//
//  CircleProgressView.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/3/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class CircleProgressView: UIView {
	
	private let currentLayer = CAShapeLayer()
	private let preloadLayer = CAShapeLayer()
	private let backgroundLayer = CAShapeLayer()
	
	private var lineWidth: CGFloat = 4
	private let currentColor = AppConstants.Color.main
	private let preloadColor = AppConstants.Color.preloadProgress
	private let trackColor = AppConstants.Color.progressTrack
	
	private var currentProgress: CGFloat = 0
	private var preloadProgress: CGFloat = 0
	
	private let trackLayer = CAShapeLayer()
	
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
		draw()
	}
	
	private func setup() {
//		backgroundLayer.backgroundColor = trackColor.cgColor
		backgroundLayer.strokeColor = trackColor.cgColor
		layer.addSublayer(backgroundLayer)
		layer.addSublayer(preloadLayer)
		layer.addSublayer(currentLayer)
		setProgress(current: 0.0, preload: 0.0)
	}
	
	private func configure() {
		trackLayer.fillColor   = nil
		trackLayer.strokeColor = UIColor.green.cgColor
		trackLayer.strokeStart = 0
		trackLayer.strokeEnd   = 0.7
		layer.addSublayer(trackLayer)
	}
	
	func setProgress(current: CGFloat? = nil, preload: CGFloat? = nil) {
		if let c = current {
			let value = (c >= 0 && c <= 1) ? c : (c > 1 ? 1 : 0)
			self.currentProgress = value
		}
		if let p = preload {
			let value = (p >= 0 && p <= 1) ? p : (p > 1 ? 1 : 0)
			self.preloadProgress = value
		}
		draw()
	}
	
	private func draw() {
		let d = min(self.frame.width, self.frame.height)
		let arcCenter = CGPoint(x: bounds.midX, y: bounds.midY)
		let circlePath = UIBezierPath(arcCenter: arcCenter,
									  radius: (d-lineWidth)/2,
									  startAngle: -.pi/2,
									  endAngle: .pi*3/2,
									  clockwise: true)
		let layers: [CAShapeLayer] = [backgroundLayer, currentLayer, preloadLayer]
		layers.forEach { layer in
			layer.frame = self.bounds
			layer.path = circlePath.cgPath
			layer.fillColor = nil
			layer.lineWidth = lineWidth
		}
		
		currentLayer.strokeStart = 0
		currentLayer.strokeEnd = currentProgress
		currentLayer.strokeColor = currentColor.cgColor

		preloadLayer.strokeStart = 0
		preloadLayer.strokeEnd = preloadProgress
		preloadLayer.strokeColor = preloadColor.cgColor
	}
}

