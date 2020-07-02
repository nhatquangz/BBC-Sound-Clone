//
//  DefaultCollectionViewHeader.swift
//  SoundBBC
//
//  Created by nhatquangz on 7/2/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift


class DefaultCollectionViewHeader: UICollectionReusableView {
	
	var sectionTitle: UILabel = {
		let label = UILabel()
		label.font = AppDefinition.Font.reithSerifMedium.size(20)
		return label
	}()
	
	var seeMoreButton: UIButton = {
		let button = UIButton()
		return button
	}()
	
	var viewModel: DefaultHeaderViewModel?
	var disposeBag = DisposeBag()
	
	// MARK: - Init
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
		self.disposeBag = DisposeBag()
	}
	
	
	// MARK: - Setup functions
	private func setup() {
		addSubview(sectionTitle)
		addSubview(seeMoreButton)
		
		sectionTitle.snp.makeConstraints {
			$0.leading.centerY.equalToSuperview()
			$0.trailing.equalTo(seeMoreButton)
		}
		
		seeMoreButton.snp.makeConstraints {
			$0.trailing.top.bottom.equalToSuperview()
			$0.width.equalTo(60)
		}
	}
	
	
	func config(viewModel: DefaultHeaderViewModel) {
		self.viewModel = viewModel
		
		viewModel.observableSectionTitle
			.bind(to: sectionTitle.rx.text)
			.disposed(by: disposeBag)
		
		self.seeMoreButton.rx.tap
			.throttle(.seconds(2), scheduler: MainScheduler.instance)
			.bind(to: viewModel.seeMoreAction)
			.disposed(by: disposeBag)
	}
}
