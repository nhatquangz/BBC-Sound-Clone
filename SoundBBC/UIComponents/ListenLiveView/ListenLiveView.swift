import Foundation
import UIKit

class ListenLiveView: UICollectionViewCell {
	
	// Dial listen live view
	@IBOutlet weak var collectionView: UICollectionView!
	
	// Information
	let channelNameLabel = UILabel()
	let channelDescriptionLabel = UILabel()
	let scheduleButton = UIButton()
	
	var data: [DisplayItemModel] = []
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()

	}
	
	private func setup() {
		// Collection View
		collectionView.collectionViewLayout = compositionalLayout()
		collectionView.backgroundColor = .clear
		contentView.backgroundColor = .clear
		collectionView.decelerationRate = .fast
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(CircleViewCell.self)
		collectionView.dataSource = self
		
		// Listen live information
		let informationView = UIStackView()
		informationView.axis = .vertical
		
		
		
	}
	
	private func compositionalLayout() -> UICollectionViewCompositionalLayout {
		let sectionLayout: NSCollectionLayoutSection = LayoutProvider(.dial).dialLayout()
		let configuration = UICollectionViewCompositionalLayoutConfiguration()
		configuration.scrollDirection = .horizontal
		let layout = SnapCenterItemCollectionViewLayout(section: sectionLayout, configuration: configuration)
		return layout
	}
	
	func centerItem() {
		collectionView.layoutIfNeeded()
		collectionView.scrollToItem(at: IndexPath(item: 1000, section: 0), at: .centeredHorizontally, animated: false)
		collectionView.collectionViewLayout.invalidateLayout()
	}
}

// MARK: - Data
extension ListenLiveView: DisplayableItemView {
	func configure<T>(data: T) {
		guard let data = data as? [DisplayItemModel] else { return }
//		self.update(data: data)
		self.data = data
		centerItem()
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


