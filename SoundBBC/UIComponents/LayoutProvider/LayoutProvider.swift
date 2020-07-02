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


class LayoutProvider {
	
	static var shared = LayoutProvider()
	
	func sectionLayout(theme: AppElementTheme) -> NSCollectionLayoutSection {
		switch theme {
		case .basicSmall:
			return basicSmallLayout()
		default:
			return basicSmallLayout()
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
	
	
	private func basicSmallLayout() -> NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(
			layoutSize:NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											  heightDimension: .fractionalHeight(0.5)))
		item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)
		
		let group = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(AppDefinition.Dimension.playableItemWidth),
											   heightDimension: .estimated(200)),
			subitem: item,
			count: 2)

		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = [defaultSectionHeader()]
		section.orthogonalScrollingBehavior = .groupPaging
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10)
		
		return section
	}
}
