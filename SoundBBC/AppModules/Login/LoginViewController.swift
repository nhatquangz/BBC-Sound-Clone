//
//  LoginViewController.swift
//  SoundBBC
//
//  Created by nhatquangz on 10/13/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import UIKit
import SafariServices
import RxCocoa
import RxSwift
import SwiftyJSON
import CryptoKit

class LoginViewController: UIViewController {
	
	let disposeBag = DisposeBag()
	weak var coordinator: LoginCoordinator?
	
	@IBOutlet weak var signButton: UIButton!
	@IBOutlet weak var registerButton: UIButton!
	
	var verifyCode: String = ""
	var challengeCode: String?
	
	@IBAction func signInAction(_ sender: Any) {
		guard let challengeCode = self.challengeCode else { return }
		self.coordinator?.request(.login, challengeCode: challengeCode)
	}
	
	@IBAction func registerAction(_ sender: Any) {
		guard let challengeCode = self.challengeCode else { return }
		self.coordinator?.request(.register, challengeCode: challengeCode)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.verifyCode = self.generateVerifyCode()
		self.challengeCode = self.generateChallengeCode(self.verifyCode)
		/// Request token when getting code
		NotificationCenter.default.rx.notification(.callbackCode)
			.flatMapLatest { [weak self] (notification) -> Observable<Result<JSON, RequestError>> in
				guard let self = self, let code = notification.userInfo?["code"] as? String else { return .empty() }
				return AppRequest.getToken(code: code, verifyCode: self.verifyCode)
			}
			.subscribe(onNext: { [weak self] result in
				if let token = try? result.get() {
					TokenManager.shared.update(jsonToken: token)
					self?.coordinator?.tabbar()
					self?.coordinator?.didFinish()
				}
			})
			.disposed(by: disposeBag)
	}
}


// MARK: - Generate code
extension LoginViewController {
	private func generateVerifyCode() -> String {
		var buffer = [UInt8](repeating: 0, count: 32)
		_ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
		let verifier = Data(buffer).base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "=", with: "")
			.replacingOccurrences(of: "/", with: "_")
			.trimmingCharacters(in: .whitespaces)
		return verifier
	}
	
	private func generateChallengeCode(_ verifier: String) -> String? {
		guard let data = verifier.data(using: .utf8) else { return nil }
		let hash = SHA256.hash(data: data)
		let bytes = Array(hash.makeIterator())
		let challenge = Data(bytes).base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
			.trimmingCharacters(in: .whitespaces)
		return challenge
	}
}

