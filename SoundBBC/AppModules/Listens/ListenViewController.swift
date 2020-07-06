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
	let refreshControl = UIRefreshControl()
	
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
		view.addSubview(collectionView)
		collectionView.insertSubview(refreshControl, at: 0)
		collectionView.backgroundColor = .white
		collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
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
		
		collectionView.dataSource = self
		
		viewModel.refreshView.asObservable()
			.subscribe(onNext: { [weak self] in
				guard let self = self else { return }
				UIView.transition(with: self.collectionView, duration: 0.4, options: .transitionCrossDissolve, animations: {
					self.collectionView.reloadData()
				}, completion: nil)
				self.refreshControl.endRefreshing()
			})
			.disposed(by: disposeBag)
		
		refreshControl.rx.controlEvent(.valueChanged)
			.throttle(.seconds(5), scheduler: MainScheduler.instance)
			.bind(to: viewModel.reloadData)
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
		
		guard let itemView = cell as? DisplayableItemView else { return cell }
		
		if cellType == ListenLiveView.self {
			itemView.configure(data: self.viewModel.items(section: indexPath.section))
		} else {
			let data = self.viewModel.item(indexPath: indexPath)
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

			
		default:
			return UICollectionReusableView()
		}
	}
}
