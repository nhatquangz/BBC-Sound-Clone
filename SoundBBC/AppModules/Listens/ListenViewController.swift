//
//  ListenViewController.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/22/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit
import SnapKit

class ListenViewController: UIViewController {
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var stackContent: UIStackView!
	

	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		createView()
		createView()
		createView()
		createView()
	}
}



// MARK: - Setup
extension ListenViewController {
	func setup() {
		self.title = "Listen"
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: AppDefinition.Font.reithSerifMedium.size(20)]
		stackContent.spacing = 20
	}
	
	func createView() {
		let section = DisplayModuleView()
		let viewmodel = DisplayModuleViewModel(data: DisplayModule(), itemType: .playable)
		section.configure(viewModel: viewmodel)
		
		stackContent.addArrangedSubview(section)
		section.snp.makeConstraints { maker in
			maker.height.equalTo(250)
		}
	}
}

