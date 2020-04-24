//
//  PagingCollectionViewFlowLayout.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit

class PagingCollectionViewFlowLayout: UICollectionViewFlowLayout {
	
	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
		var offsetAdjustment = CGFloat.greatestFiniteMagnitude
		let horizontalOffset = proposedContentOffset.x
		let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: self.collectionView!.bounds.size)

		for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
			let itemOffset = layoutAttributes.frame.origin.x
			if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
				offsetAdjustment = itemOffset - horizontalOffset
			}
		}

		return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
	}
	
}
