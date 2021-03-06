import Foundation
import UIKit
import MarqueeLabel
import RxCocoa
import RxSwift


class PlayingView: UIView {
	
	let nibName = "PlayingView"
	@IBOutlet weak var contentView: UIView!
	
	@IBOutlet weak var smallPlayBar: UIView!
	@IBOutlet weak var dropdownImage: UIImageView!
	
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
	
	@IBOutlet weak var fullScreenButton: UIButton!
	
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
		playingTrack.setThumbImage(UIImage(named: "thumb-small"), for: .normal)
		playingTrack.setThumbImage(UIImage(named: "thumb-large"), for: .highlighted)
		
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
		
		viewModel.playingState
			.map { $0.isPlay }
			.bind(to: playButtons[0].rx.isSelected, playButtons[1].rx.isSelected)
			.disposed(by: disposeBag)
		
		viewModel.playingTrackValue.asObservable()
			.subscribe(onNext: { [weak self] value in
				guard let self = self else { return }
				self.playingTrack.value = value
				let maxValue = self.circleProgress[0].maxValue
				let currentPercent = CGFloat(value / maxValue)
				self.circleProgress.forEach {
					$0.setProgress(current: currentPercent)
				}
			})
		.disposed(by: disposeBag)
		
		viewModel.duration.asObservable()
			.subscribe(onNext: { [weak self] duration in
				self?.durationLabel.text = duration.asString(style: .positional)
				self?.playingTrack.maximumValue = Float(duration)
				self?.circleProgress.forEach { $0.maxValue = Float(duration) }
			})
			.disposed(by: disposeBag)
		
		viewModel.currentTimeString.asObservable()
			.bind(to: currentTimeLabel.rx.text)
			.disposed(by: disposeBag)
		
		playingTrack.rx.observeWeakly(Bool.self, #keyPath(UISlider.isTracking))
			.unwrap()
			.distinctUntilChanged()
			.debug("is tracking")
			.bind(to: viewModel.isSeeking)
			.disposed(by: disposeBag)
		
		playButtons.forEach { (button) in
			button.rx.tap.asDriver()
				.throttle(.seconds(1))
				.map { nil }
				.drive(viewModel.play)
				.disposed(by: disposeBag)
		}
		
		playingTrack.rx.value
			.map { Double($0) }
			.bind(to: viewModel.seekTime)
			.disposed(by: disposeBag)
		
		let seekBackward = rewindBack.rx.tap.asDriver().map { -20.0 }
		let seekForward = rewindForward.rx.tap.asDriver().map { 20.0 }
		seekBackward.asObservable().merge(with: seekForward.asObservable())
			.bind(to: viewModel.rewindAmount)
			.disposed(by: disposeBag)
		
		fullScreenButton.rx.tap.asDriver()
			.throttle(.seconds(1))
			.map { PlayingViewPosition.full }
			.drive(viewModel.position)
			.disposed(by: disposeBag)
	}
}
