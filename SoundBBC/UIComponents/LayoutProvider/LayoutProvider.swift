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
		case dial = "dial"
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
	
	static var shared = LayoutProvider(.basic)
	
	var sectionLayout: NSCollectionLayoutSection!
	var itemViewType: UICollectionViewCell.Type!
	
	init(_ theme: AppElementTheme, numberOfItems: Int = 2) {
		switch theme {
		case .basicSmall:
			let columnCount = numberOfItems < 2 ? numberOfItems : 2
			sectionLayout = basicLayout(columnItemCount: columnCount)
			itemViewType = PlayableViewCell.self
			
		case .basicLarge:
			let columnCount = numberOfItems < 3 ? numberOfItems : 3
			sectionLayout = basicLayout(columnItemCount: columnCount)
			itemViewType = PlayableViewCell.self
			
		case .impactLarge:
			sectionLayout = impactLargeLayout()
			itemViewType = ImpactLargeViewCell.self
			
		case .impactSmall:
			sectionLayout = impactSmallLayout()
			itemViewType = ImpactSmallViewCell.self
		
		case .dial:
			sectionLayout = dialLayout()
			itemViewType = CircleViewCell.self
			
		default:
			sectionLayout = basicLayout()
			itemViewType = PlayableViewCell.self
		}
	}
}



// MARK: - Layouts
extension LayoutProvider {
	private func defaultSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
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
		group.interItemSpacing = .fixed(itemSpace)
		
		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = [defaultSectionHeader()]
		section.orthogonalScrollingBehavior = .groupPaging
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: itemSpace, bottom: itemSpace, trailing: itemSpace)
		
		return section
	}
	
	
	private func impactLargeLayout() -> NSCollectionLayoutSection {
		let itemSpace = AppDefinition.Dimension.itemSpace - 5
		let itemWidth = UIScreen.main.bounds.width * 0.5
		let itemHeight = itemWidth + 90
		let sectionPadding = AppDefinition.Dimension.contenPadding
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											  heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
											   heightDimension: .absolute(itemHeight))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
													   subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = [defaultSectionHeader()]
		section.orthogonalScrollingBehavior = .continuous
		section.interGroupSpacing = itemSpace
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sectionPadding, bottom: sectionPadding, trailing: sectionPadding)
		
		return section
	}
	
	
	private func impactSmallLayout() -> NSCollectionLayoutSection {
		let itemSpace = AppDefinition.Dimension.itemSpace - 5
		let itemHeight: CGFloat = 80.0
		let itemWidth = itemHeight * 1.5
		let sectionPadding = AppDefinition.Dimension.contenPadding
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											  heightDimension: .fractionalHeight(0.5))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
											   heightDimension: .absolute(itemHeight * 2 + itemSpace))
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
													   subitem: item,
													   count: 2)
		group.interItemSpacing = .fixed(itemSpace)
		
		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = [defaultSectionHeader()]
		section.orthogonalScrollingBehavior = .continuous
		section.interGroupSpacing = itemSpace
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sectionPadding, bottom: sectionPadding, trailing: sectionPadding)
		
		return section
	}
	
	
	private func dialLayout() -> NSCollectionLayoutSection {
		let itemHeight = AppDefinition.Dimension.dialItemHeight
		let itemSpace = AppDefinition.Dimension.itemSpace
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											  heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemHeight),
											   heightDimension: .absolute(itemHeight))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
													   subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
		section.interGroupSpacing = itemSpace - 5
		section.contentInsets = NSDirectionalEdgeInsets(top: itemSpace, leading: 0, bottom: itemSpace, trailing: 0)
		
		section.visibleItemsInvalidationHandler = { items, offset, env in
			let r = CGRect(origin: offset, size: env.container.contentSize)
			let cells = items.filter { $0.representedElementCategory == .cell }
			for item in cells {
				let d = abs(r.midX - item.center.x)
				let tolerance : CGFloat = 0.02
				var scale = 1.0 + tolerance - (d / r.size.width * 2) * 0.2
				if (scale > 1.0) {
					scale = 1.0
				}
				let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
				let y = d * 0.15
				let translationYTransform = CGAffineTransform(translationX: 0, y: y)
				item.transform = scaleTransform.concatenating(translationYTransform)
			}
		}
		return section
	}
}
