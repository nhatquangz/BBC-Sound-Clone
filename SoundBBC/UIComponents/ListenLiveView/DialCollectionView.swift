//
//  DialCollectionView.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/4/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit

class DialCollectionLayout: UICollectionViewCompositionalLayout {
	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
		guard let collectionView = collectionView else {
			return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
		}
		var offsetAdjusment = CGFloat.greatestFiniteMagnitude
		let horizontalCenter = proposedContentOffset.x + (collectionView.bounds.width / 2)
		
		let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
		let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
		
		layoutAttributesArray?.forEach({ (layoutAttributes) in
			let itemHorizontalCenter = layoutAttributes.center.x
			if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjusment) {
				offsetAdjusment = itemHorizontalCenter - horizontalCenter
			}
		})
		return CGPoint(x: proposedContentOffset.x + offsetAdjusment, y: proposedContentOffset.y)
	}
}
