import Foundation
import UIKit

class DisplayModuleView: UIView {
	
	let nibName = "DisplayModuleView"
	
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var viewModel: DisplayModuleViewModel?
	private var indexOfCellBeforeDragging = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
		collectionView.register(fromClass: DisplayItemCell.self)
		collectionView.delegate = self
		collectionView.dataSource = self
//		collectionView.isPagingEnabled = true
		collectionView.showsHorizontalScrollIndicator = false
		if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.scrollDirection = .horizontal
			layout.minimumLineSpacing = 0
			layout.minimumInteritemSpacing = 10
		}
		let leftrightPadding = AppDefinition.Dimension.contentPadding
		collectionView.contentInset = UIEdgeInsets(top: 0, left: leftrightPadding, bottom: 0, right: leftrightPadding)
	}
	
	func configure(viewModel: DisplayModuleViewModel) {
		self.viewModel = viewModel
	}
}

// MARK: - Collection view delegate
extension DisplayModuleView: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel?.data.items.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeue(DisplayItemCell.self, for: indexPath)
		if let itemData = viewModel?.data.items[indexPath.row],
			let itemType = viewModel?.itemType {
			cell.configure(data: itemData, type: itemType)
		}
		return cell
	}
}


extension DisplayModuleView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return viewModel?.itemSize ?? .zero
	}
}


extension DisplayModuleView: UIScrollViewDelegate {
}

