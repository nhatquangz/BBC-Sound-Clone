import Foundation
import UIKit
import MarqueeLabel

class PlayingView: UIView {
	
	let nibName = "PlayingView"
	@IBOutlet weak var contentView: UIView!
	
	@IBOutlet var images: [UIImageView]!
	@IBOutlet var songTitles: [MarqueeLabel]!
	@IBOutlet var songDescriptions: [MarqueeLabel]!
	
	@IBOutlet weak var playingTrack: CustomSlider!
	@IBOutlet weak var currentTimeLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!
	
	@IBOutlet weak var previousSong: UIButton!
	@IBOutlet weak var rewindBack: UIButton!
	@IBOutlet weak var rewindForward: UIButton!
	@IBOutlet weak var nextSong: UIButton!
	
	@IBOutlet weak var circleProgress: CircleProgressView!
	
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
		
		playingTrack.minimumTrackTintColor = AppConstants.Color.main
		playingTrack.thumbTintColor = AppConstants.Color.main
	}
}
