//
//  MusicViewController.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/16/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit

class MusicViewController: UIViewController {
	
	var collectionView: UICollectionView!
	let viewModel = MusicViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
		setup()
    }
}

// MARK: - Setup UI
extension MusicViewController {
	func setup() {
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: musicLayout())
	}
	
	func musicLayout() -> UICollectionViewCompositionalLayout {
		return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			let theme = self.viewModel.theme(forSection: sectionIndex)
			let numberOfItems = self.viewModel.numberOfItems(inSection: sectionIndex)
			let layout = LayoutProvider(theme, numberOfItems: numberOfItems).sectionLayout
			return layout
		}
	}
}

