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
		case spotlight_curation_unfamiliar
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
			sectionLayout = listenLive()
			itemViewType = ListenLiveView.self
			
		default:
			sectionLayout = basicLayout()
			itemViewType = PlayableViewCell.self
		}
	}
}



// MARK: - Layouts
extension LayoutProvider {
	private func supplementaryView(height: NSCollectionLayoutDimension,
								   width: NSCollectionLayoutDimension = .fractionalWidth(1),
								   kind: String = UICollectionView.elementKindSectionHeader,
								   alignment: NSRectAlignment) -> NSCollectionLayoutBoundarySupplementaryItem {
		
		let size = NSCollectionLayoutSize(widthDimension: width,
												heightDimension: height)
		let reuseView = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size,
																 elementKind: kind,
																 alignment: alignment)
		return reuseView
	}
	
	private func defaultSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
		return supplementaryView(height: .absolute(50), alignment: .top)
	}
	
	
	private func basicLayout(columnItemCount: Int = 2) -> NSCollectionLayoutSection {
		let itemSpace = AppConstants.Dimension.itemSpace
		let itemHeight = AppConstants.Dimension.playableItemHeight
		let itemWidth = AppConstants.Dimension.playableItemWidth
		
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
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: itemSpace, bottom: itemSpace, trailing: itemSpace-5)
		
		return section
	}
	
	
	private func impactLargeLayout() -> NSCollectionLayoutSection {
		let itemSpace = AppConstants.Dimension.itemSpace - 5
		let itemWidth = UIScreen.main.bounds.width * 0.6
		let itemHeight = itemWidth + 90
		let sectionPadding = AppConstants.Dimension.contenPadding
		
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
		let itemSpace = AppConstants.Dimension.itemSpace * 0.5
		let itemHeight = AppConstants.Dimension.categoryItemHeight
		let itemWidth = itemHeight * 1.8
		let sectionPadding = AppConstants.Dimension.contenPadding
		
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
	
	
	private func listenLive() -> NSCollectionLayoutSection {
		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
										  heightDimension: .estimated(200))
		let item = NSCollectionLayoutItem(layoutSize: size)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
													   subitems: [item])
		let section = NSCollectionLayoutSection(group: group)
		return section
	}
	
	func dialLayout() -> NSCollectionLayoutSection {
		let itemHeight = AppConstants.Dimension.dialItemHeight
		let itemSpace = AppConstants.Dimension.itemSpace
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											  heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemHeight),
											   heightDimension: .absolute(itemHeight))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
													   subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = itemSpace
		section.contentInsets = NSDirectionalEdgeInsets(top: 60, leading: 0, bottom: 0, trailing: 0)
		
		section.visibleItemsInvalidationHandler = { items, offset, env in
			let r = CGRect(origin: offset, size: env.container.contentSize)
			let cells = items.filter { $0.representedElementCategory == .cell }
			for item in cells {
				let d = abs(r.midX - item.center.x)
				var scale = 1.15 - d / (r.size.width / 2)
				if (scale < 0.95) {
					scale = 0.95
				}
				let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
				var y = -35 * (1 - d / (r.size.width / 2))
				if y > 0 { y = 0 }
				let translationYTransform = CGAffineTransform(translationX: 0, y: y)
				item.transform = scaleTransform.concatenating(translationYTransform)
			}
		}
		return section
	}
}
