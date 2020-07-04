import Foundation
import UIKit

class ListenLiveView: UICollectionViewCell {
	
	// Dial listen live view
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<String, DisplayItemModel>! = nil
	
	var data: [DisplayItemModel] = []
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		print(self.className)
	}
	
	private func setup() {
		collectionView = UICollectionView(frame: .zero,
										  collectionViewLayout: compositionalLayout())
		contentView.addSubview(collectionView)
		collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
		collectionView.backgroundColor = .clear
		contentView.backgroundColor = .clear
		collectionView.decelerationRate = .fast
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(CircleViewCell.self)
//		configureDataSource()
		collectionView.dataSource = self
		collectionView.delegate = self
	}
	
	private func compositionalLayout() -> UICollectionViewCompositionalLayout {
		let sectionLayout: NSCollectionLayoutSection = LayoutProvider(.dial).dialLayout()
		let configuration = UICollectionViewCompositionalLayoutConfiguration()
		configuration.scrollDirection = .horizontal
		let layout = DialCollectionLayout(section: sectionLayout, configuration: configuration)
		return layout
	}
	
	func configureDataSource() {
		self.dataSource = UICollectionViewDiffableDataSource<String, DisplayItemModel>(collectionView: self.collectionView)
		{ (collectionView: UICollectionView, indexPath: IndexPath, item: DisplayItemModel) -> UICollectionViewCell? in
			let cell = collectionView.dequeueReusableCell(with: CircleViewCell.self, for: indexPath)
			return cell
		}
	}
}

// MARK: - Data
extension ListenLiveView: DisplayableItemView {
	func configure<T>(data: T) {
		guard let data = data as? [DisplayItemModel] else { return }
//		self.update(data: data)
		self.data = data
//		self.collectionView.reloadData()
	}
	
	private func update(data: [DisplayItemModel]) {
		var snapshot = NSDiffableDataSourceSnapshot<String, DisplayItemModel>()
		let sectionID = "ListenLiveView"
		snapshot.appendSections([sectionID])
		snapshot.appendItems(data, toSection: sectionID)
		self.dataSource.apply(snapshot)
	}
}


// MARK: - CollectionView
extension ListenLiveView: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 99999
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(with: CircleViewCell.self, for: indexPath)
		if let viewCell = cell as? DisplayableItemView {
			viewCell.configure(data: data)
		}
		return cell
	}
}


