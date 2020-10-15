# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SoundBBC' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SoundBBC
   #UI
	pod 'IQKeyboardManagerSwift', '6.5.0'
	pod 'SnapKit', '5.0.1'
	pod 'NVActivityIndicatorView', '4.8.0'
	pod 'MarqueeLabel', '4.0.2'
	
	#Extension
	pod 'SwiftDate', '6.1.0'
	pod 'RxSwift', '5.1.1'
	pod 'RxCocoa', '5.1.1'
	pod 'RxSwiftExt', '5.2.0'
	# pod 'RxGesture', '2.2.0'
	
	#Services & Network
	pod 'Alamofire', '5.1'
	pod 'Kingfisher', '5.15.6'
	
	#Database
	pod 'SwiftyJSON', '5.0.0'
	pod 'KeychainAccess', '4.2.0'

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
		end
	end
end
