//
//  ImpactSmallViewCell.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/2/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ImpactSmallViewCell: UICollectionViewCell {
    
	var disposeBag = DisposeBag()
	
	let coverImageView: UIImageView = {
		let imageview = UIImageView()
		imageview.clipsToBounds = true
		imageview.contentMode = .scaleAspectFill
		return imageview
	}()
	
	let categoryName: UILabel = {
		let label = UILabel()
		label.font = AppConstants.Font.reithSansBold.size(15)
		label.numberOfLines = 3
		label.textAlignment = .center
		label.textColor = .white
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		addSubview(coverImageView)
		addSubview(categoryName)
		coverImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
		categoryName.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
	
	override func prepareForReuse() {
		self.disposeBag = DisposeBag()
		super.prepareForReuse()
	}
}


extension ImpactSmallViewCell: DisplayableItemView {
	func configure<T>(data: T) {
		let viewModel = data as? ListenCellViewModel
		let imageURL = viewModel?.imageURL(placeholders: [.recipe: "320x180"])
		coverImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.4))])
		viewModel?.title.bind(to: categoryName.rx.text).disposed(by: disposeBag)
	}
}

