import Foundation
import UIKit
import MarqueeLabel
import RxCocoa
import RxSwift


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
	@IBOutlet var playButtons: [UIButton]!
	
	
	@IBOutlet var circleProgress: [CircleProgressView]!
	
	@IBOutlet weak var airplayConnectButton: UIButton!
	
	let disposeBag = DisposeBag()
	
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
		
		/// Airplay connect button title
		let airplayTitle = NSMutableAttributedString(string: "Available Devices\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
		let airplayIcon = NSTextAttachment()
		airplayIcon.image = UIImage(named: "airplay-audio")
		let airplay = NSAttributedString(attachment: airplayIcon)
		airplayTitle.append(airplay)
		airplayTitle.append(NSAttributedString(string: " Connect to AirPlay"))
		
		airplayConnectButton.setAttributedTitle(airplayTitle, for: .normal)
		airplayConnectButton.titleLabel?.textAlignment = .center
		
		bindData()
	}
	
	private func bindData() {
		let viewModel = PlayingViewModel.shared
		viewModel.songImage.asObservable()
			.subscribe(onNext: { [weak self] imageURL in
				self?.images.forEach { imageView in
					imageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.4))])
				}
			})
			.disposed(by: disposeBag)
		
		viewModel.songDescription.asObservable()
			.bind(to: songDescriptions[0].rx.text, songDescriptions[1].rx.text)
			.disposed(by: disposeBag)
		
		viewModel.songTitle.asObservable()
			.bind(to: songTitles[0].rx.text, songTitles[1].rx.text)
			.disposed(by: disposeBag)
		
		viewModel.playingStateObservable
			.map { $0.isPlay }
			.bind(to: playButtons[0].rx.isSelected, playButtons[1].rx.isSelected)
			.disposed(by: disposeBag)
		
		playButtons.forEach { (button) in
			button.rx.tap.asDriver()
				.throttle(.seconds(1))
				.map { nil }
				.drive(viewModel.play)
				.disposed(by: disposeBag)
		}
	}
}
