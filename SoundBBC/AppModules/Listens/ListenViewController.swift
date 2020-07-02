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
	var dataSource: UICollectionViewDiffableDataSource<String, DisplayItemModel>! = nil
	
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
		
		collectionView.register(PlayableViewCell.self)
		collectionView.register(ContainerViewCell.self, forCellWithReuseIdentifier: ContainerViewCell.className)
		collectionView.register(DefaultCollectionViewHeader.self,
								forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
								withReuseIdentifier: DefaultCollectionViewHeader.className)

		configureDataSource()
		
		viewModel.refreshView.asObservable()
			.subscribe(onNext: { [weak self] in
				guard let self = self else { return }
				let snapshot = self.viewModel.snapshotData()
				self.dataSource.apply(snapshot, animatingDifferences: true)
			})
			.disposed(by: disposeBag)
	}
	
	func compositionalLayout() -> UICollectionViewCompositionalLayout {
		return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			let theme = self.viewModel.theme(forSection: sectionIndex)
			let numberOfItems = self.viewModel.numberOfItems(inSection: sectionIndex)
			return LayoutProvider.shared.sectionLayout(theme: theme,
													   numberOfItems: numberOfItems)
		}
	}
	
	func configureDataSource() {
		self.dataSource = UICollectionViewDiffableDataSource<String, DisplayItemModel>(collectionView: self.collectionView)
		{ (collectionView: UICollectionView, indexPath: IndexPath, item: DisplayItemModel) -> UICollectionViewCell? in
			let theme = self.viewModel.theme(forSection: indexPath.section)
			let cellType = LayoutProvider.shared.itemViewType(for: theme)
			let cell = collectionView.dequeueReusableCell(with: cellType, for: indexPath)
			return cell
		}
		
		dataSource.supplementaryViewProvider = { [weak self]
			(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																		 withReuseIdentifier: DefaultCollectionViewHeader.className,
																		 for: indexPath) as! DefaultCollectionViewHeader
			if let headerViewModel = self?.viewModel.headerViewModel(index: indexPath) {
				header.config(viewModel: headerViewModel)
			}
			return header
		}
	}
}


