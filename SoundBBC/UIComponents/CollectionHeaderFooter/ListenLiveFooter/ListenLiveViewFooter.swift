import Foundation
import UIKit

class ListenLiveViewFooter: UICollectionReusableView {
	
	let nibName = "ListenLiveViewFooter"
	@IBOutlet weak var contentView: UIView!
	
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
		contentView.backgroundColor = .random
	}
}
