//
//  CollectionTableViewExtension.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/24/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit

public protocol ClassNameProtocol {
	static var className: String { get }
	var className: String { get }
}

public extension ClassNameProtocol {
	static var className: String {
		return String(describing: self)
	}
	
	var className: String {
		return type(of: self).className
	}
}

extension NSObject: ClassNameProtocol {}

public extension UITableView {
	func register<T: UITableViewCell>(_ cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

	func register<T: UITableViewCell>(_ cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register($0, bundle: bundle) }
    }

	func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
	}
}


public extension UICollectionView {
	func register<T: UICollectionViewCell>(_ cellType: T.Type, bundle: Bundle? = nil) {
		let className = cellType.className
		if Bundle.main.path(forResource: className, ofType: "nib") == nil {
			register(cellType, forCellWithReuseIdentifier: className)
			return
		}
		let nib = UINib(nibName: className, bundle: bundle)
		register(nib, forCellWithReuseIdentifier: className)
	}
	
	func register<T: UICollectionViewCell>(_ cellTypes: [T.Type], bundle: Bundle? = nil) {
		cellTypes.forEach { register($0, bundle: bundle) }
	}
	
	func register<T: UICollectionReusableView>(reusableViewType: T.Type,
											   ofKind kind: String = UICollectionView.elementKindSectionHeader,
											   bundle: Bundle? = nil) {
		let className = reusableViewType.className
		if Bundle.main.path(forResource: className, ofType: "nib") == nil {
			register(reusableViewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
			return
		}
		let nib = UINib(nibName: className, bundle: bundle)
		register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
	}
	
	func register<T: UICollectionReusableView>(reusableViewTypes: [T.Type],
											   ofKind kind: String = UICollectionView.elementKindSectionHeader,
											   bundle: Bundle? = nil) {
		reusableViewTypes.forEach { register(reusableViewType: $0, ofKind: kind, bundle: bundle) }
	}
	
	func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type,
													  for indexPath: IndexPath) -> T {
		return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
	}
	
	func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type,
														  for indexPath: IndexPath,
														  ofKind kind: String = UICollectionView.elementKindSectionHeader) -> T {
		return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as! T
	}
}
