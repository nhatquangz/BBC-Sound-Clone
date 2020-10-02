//
//  ListenCellViewModel.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/1/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class ListenCellViewModel: BaseViewModel {
	
	// Output
//	let imageURL = BehaviorRelay<URL?>(value: nil)
	let title = BehaviorRelay<String>(value: "")
	let synopses = BehaviorRelay<String>(value: "")
	let descriptionText = BehaviorRelay<String>(value: "")
	let dateTimeText = BehaviorRelay<String>(value: "")
	let showProgressBar = BehaviorRelay<Bool>(value: false)
	let currentProgress = BehaviorRelay<CGFloat>(value: 0)
	
	private let data: DisplayItemModel
	
	init(data: DisplayItemModel) {
		self.data = data
		title.accept(data.titles?.primary ?? "")
		descriptionText.accept("\(data.titles?.secondary ?? "")\n\(data.titles?.tertiary ?? "")")
		synopses.accept(data.synopses?.short ?? "")
		
		if let progress = data.currentProgress() {
			dateTimeText.accept(data.progress?.label ?? "")
			showProgressBar.accept(false)
			currentProgress.accept(CGFloat(progress))
		} else {
			dateTimeText.accept(data.duration?.label ?? "")
			showProgressBar.accept(true)
		}
	}
	
	func imageURL(placeholders: [AppExtensionWrapper<String>.Placeholder: String]) -> URL? {
		return data.imageUrl?.bbc.replace(placeholders).urlEncoded
	}
	

}
