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
		let viewCells: [UICollectionViewCell.Type] = [PlayableViewCell.self,
													  ImpactLargeViewCell.self,
													  ImpactSmallViewCell.self,
													  ContainerViewCell.self,
													  CircleViewCell.self,
													  ListenLiveView.self]
		
		collectionView.register(viewCells)
		collectionView.register(DefaultCollectionViewHeader.self,
								forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
								withReuseIdentifier: DefaultCollectionViewHeader.className)
		collectionView.register(ListenLiveViewFooter.self,
								forSupplementaryViewOfKind: ListenLiveViewFooter.className,
								withReuseIdentifier: ListenLiveViewFooter.className)
		
//				configureDataSource()
		collectionView.dataSource = self

		viewModel.refreshView.asObservable()
			.subscribe(onNext: { [weak self] in
				guard let self = self else { return }
//				let snapshot = self.viewModel.snapshotData()
//				self.dataSource.apply(snapshot, animatingDifferences: true)
				self.collectionView.reloadData()
			})
			.disposed(by: disposeBag)
	}
	
	
	func compositionalLayout() -> UICollectionViewCompositionalLayout {
		return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			let theme = self.viewModel.theme(forSection: sectionIndex)
			let numberOfItems = self.viewModel.numberOfItems(inSection: sectionIndex)
			let layout = LayoutProvider(theme, numberOfItems: numberOfItems).sectionLayout
			return layout
		}
	}
	
	
	func configureDataSource() {
		self.dataSource = UICollectionViewDiffableDataSource<String, DisplayItemModel>(collectionView: self.collectionView)
		{ (collectionView: UICollectionView, indexPath: IndexPath, item: DisplayItemModel) -> UICollectionViewCell? in
			let theme = self.viewModel.theme(forSection: indexPath.section)
			let cellType: UICollectionViewCell.Type = LayoutProvider(theme).itemViewType
			let cell = collectionView.dequeueReusableCell(with: cellType, for: indexPath)
			return cell
		}
		
		dataSource.supplementaryViewProvider = { [weak self]
			(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
			
			switch kind {
			case UICollectionView.elementKindSectionHeader:
				let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																			 withReuseIdentifier: DefaultCollectionViewHeader.className,
																			 for: indexPath) as! DefaultCollectionViewHeader
				if let headerViewModel = self?.viewModel.headerViewModel(index: indexPath) {
					header.config(viewModel: headerViewModel)
				}
				return header
				
			case ListenLiveViewFooter.className:
				let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																			 withReuseIdentifier: ListenLiveViewFooter.className,
																			 for: indexPath) as! ListenLiveViewFooter
				return footer
				
			default:
				return UICollectionReusableView()
			}
		}
	}
}


// MARK: - Data source
extension ListenViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return viewModel.numberOfSection()
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfItems(inSection: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let theme = self.viewModel.theme(forSection: indexPath.section)
		let cellType: UICollectionViewCell.Type = LayoutProvider(theme).itemViewType
		let cell = collectionView.dequeueReusableCell(with: cellType, for: indexPath)
		if let itemView = cell as? DisplayableItemView {
			let data = self.viewModel.data(section: indexPath.section)
			itemView.configure(data: data)
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																		 withReuseIdentifier: DefaultCollectionViewHeader.className,
																		 for: indexPath) as! DefaultCollectionViewHeader
			if let headerViewModel = self.viewModel.headerViewModel(index: indexPath) {
				header.config(viewModel: headerViewModel)
			}
			return header
			
		case ListenLiveViewFooter.className:
			let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																		 withReuseIdentifier: ListenLiveViewFooter.className,
																		 for: indexPath) as! ListenLiveViewFooter
			return footer
			
		default:
			return UICollectionReusableView()
		}
	}
}

