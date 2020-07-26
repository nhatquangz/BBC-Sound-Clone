import Foundation
import UIKit
import RxCocoa
import RxSwift


class ListenLiveView: UICollectionViewCell {
	
	// Dial listen live view
	@IBOutlet weak var collectionView: UICollectionView!
	
	// Information
	@IBOutlet weak var channelNameLabel: UILabel!
	@IBOutlet weak var channelDescriptionLabel: UILabel!
	
	var viewModel: ListenLiveViewModel?
	var disposeBag = DisposeBag()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = DisposeBag()
	}
	
	private func setup() {
		collectionView.collectionViewLayout = compositionalLayout()
		collectionView.backgroundColor = .clear
		contentView.backgroundColor = .clear
		collectionView.decelerationRate = .fast
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(CircleViewCell.self)
		collectionView.dataSource = self
	}
	
	private func compositionalLayout() -> UICollectionViewCompositionalLayout {
		let sectionLayout: NSCollectionLayoutSection = LayoutProvider(.dial).dialLayout()
		let configuration = UICollectionViewCompositionalLayoutConfiguration()
		configuration.scrollDirection = .horizontal
		let layout = SnapCenterItemCollectionViewLayout(section: sectionLayout, configuration: configuration)
		return layout
	}
	
	func scrollToCenter() {
		self.layoutIfNeeded()
		collectionView.scrollToItem(at: IndexPath(item: 500000, section: 0), at: .centeredHorizontally, animated: false)
		collectionView.collectionViewLayout.invalidateLayout()
	}
}


// MARK: - Data
extension ListenLiveView: DisplayableItemView {
	func configure<T>(data: T) {
		guard let data = data as? [DisplayItemModel] else { return }
		let viewModel = ListenLiveViewModel(data: data)
		self.viewModel = viewModel
		bindData(viewModel: viewModel)
		collectionView.reloadData()
		self.scrollToCenter()
	}
	
	private func bindData(viewModel: ListenLiveViewModel) {
		collectionView.rx.contentOffset
			.map { $0.x }
			.bind(to: viewModel.currentOffset)
			.disposed(by: disposeBag)
		
		viewModel.channelTitle.asDriver()
			.drive(channelNameLabel.rx.text)
			.disposed(by: disposeBag)
		
		viewModel.channelDescription.asDriver()
			.drive(channelDescriptionLabel.rx.text)
			.disposed(by: disposeBag)
	}
	
}


// MARK: - CollectionView
extension ListenLiveView: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 999999
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let viewCell = collectionView.dequeueReusableCell(with: CircleViewCell.self, for: indexPath)
		if let data = viewModel?.dataChannel(index: indexPath.row) {
			viewCell.configure(data: data)
		}
		return viewCell
	}
}


