//
//  ListenViewController.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ListenViewController: UIViewController {
	
	let disposeBag = DisposeBag()
	var collectionView: UICollectionView!
	let viewModel = ListenViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
}



// MARK: - Setup
extension ListenViewController {
	func setup() {
		self.title = "Listen"
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: AppDefinition.Font.reithSerifMedium.size(20)]
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout())
		self.view.addSubview(collectionView)
		self.collectionView.backgroundColor = .white
		collectionView.snp.makeConstraints { constraint in
			constraint.edges.equalToSuperview()
		}
		
		collectionView.dataSource = self
		collectionView.register(PlayableViewCell.self)
		
		viewModel.refreshView.asObservable()
			.subscribe(onNext: { [weak self] in
				self?.collectionView.reloadData()
			})
			.disposed(by: disposeBag)
	}
	
	func compositionalLayout() -> UICollectionViewCompositionalLayout {
		return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			let theme = self.viewModel.theme(forSection: sectionIndex)
			return LayoutProvider.shared.sectionLayout(theme: theme)
		}
	}
}


// MARK: - Collectionview
extension ListenViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return viewModel.numberOfSection()
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfItems(inSection: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let theme = self.viewModel.theme(forSection: indexPath.section)
		let cellType = LayoutProvider.shared.itemView(for: theme)
		let cell = collectionView.dequeueReusableCell(with: cellType, for: indexPath)
		return cell
	}
}


