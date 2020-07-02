//
//  CollectionViewLayoutProvider.swift
//  SoundBBC
//
//  Created by nhatquangz on 6/29/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Theme
extension LayoutProvider {
	enum AppElementTheme: String {
		case basic = "basic"
		case basicSmall = "basic_small"
		case basicLarge = "basic_large"
		case impact = "impact"
		case impactAlt = "impact_alt"
		case impactSmall = "impact_small"
		case impactLarge = "impact_large"
		case schedule = "schdule"
		case index = "index"
		case unknown
	}
}


class LayoutProvider: NSObject {
	
	static var shared = LayoutProvider()
	
	func sectionLayout(theme: AppElementTheme, numberOfItems: Int = 2) -> NSCollectionLayoutSection {
		switch theme {
		case .basicSmall:
			let columnCount = numberOfItems < 2 ? numberOfItems : 2
			return basicLayout(columnItemCount: columnCount)
		
		case .basicLarge:
			let columnCount = numberOfItems < 3 ? numberOfItems : 3
			return basicLayout(columnItemCount: columnCount)
			
		default:
			return basicLayout()
		}
	}
	
	
	func itemViewType(for theme: AppElementTheme) -> UICollectionViewCell.Type {
		switch theme {
		case .basicSmall:
			return PlayableViewCell.self
		default:
			return PlayableViewCell.self
		}
	}
	
	
	func defaultSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
		let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
												heightDimension: .absolute(50))
		let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
																 elementKind: UICollectionView.elementKindSectionHeader,
																 alignment: .top)
		return header
	}
	
	
	private func basicLayout(columnItemCount: Int = 2) -> NSCollectionLayoutSection {
		let itemSpace = AppDefinition.Dimension.itemSpace
		let itemHeight = AppDefinition.Dimension.playableItemHeight
		let itemWidth = AppDefinition.Dimension.playableItemWidth
		
		let item = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											  heightDimension: .absolute(itemHeight)))
		
		let groupHeight = itemHeight * CGFloat(columnItemCount) + itemSpace * CGFloat(columnItemCount - 1)
		let group = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(itemWidth),
											   heightDimension: .estimated(groupHeight)),
			subitem: item,
			count: columnItemCount)
		group.interItemSpacing = .fixed(15)
		
		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = [defaultSectionHeader()]
		section.orthogonalScrollingBehavior = .groupPaging
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: itemSpace + 5, bottom: itemSpace + 5, trailing: itemSpace - 5)
		
		return section
	}
}
