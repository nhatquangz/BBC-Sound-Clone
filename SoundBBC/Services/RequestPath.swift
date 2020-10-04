//
//  RequestPath.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation
import SwiftyJSON


enum RequestPath: String {
	case listen = "listenPath"
	case plays = "playsPath"
	case search = "searchPath"
	case allStattions = "allStationsPath"
	case activities = "activitiesPath"
	case mySounds = "mySoundsPath"
	case broadcast = "broadcastsPath"
	case tracklists = "tracklistsPath"
	case containerTemplateInLine = "containerTemplatePathInline"
	case playableDetailTemplate = "playableDetailTemplatePath"
	case playableNetworkTemplate = "playableNetworkTemplatePath"
	case schedulesTemplate = "schedulesTemplatePath"
	case playQueueTemplate = "playQueueTemplatePath"
	case experiments = "experimentsPath"
	case experimentsAttributes = "experimentsAttributesPath"
	case liveTrackNowPlaying = "liveTrackNowPlayingPath"
	case inCarIndex = "inCarIndexPath"
	case categoriesIndex = "categoriesIndexPath"
	case playableNetworks = "playableNetworksPath"
	
	case playmedia
	
	case refreshToken = "/tokens"
	case config = "/ios/{version}/config.json"
	
	enum Destination {
		case rms, config, session, playback
	}
}



extension RequestPath {
	static func baseURL(_ destination: Destination) -> String {
		switch destination {
		case .rms:
			return AppConfiguration.shared.rmsConfig("rootUrl") ?? ""
			
		case .config:
			return "https://sounds-mobile-config.files.bbci.co.uk"
			
		case .session:
			return "https://session.bbc.co.uk/session"
			
		case .playback:
			return AppConfiguration.shared.playbackURL
		}
	}
	
	static func createURL(destination: RequestPath.Destination = .rms, path: String) -> String {
		return String(format: "%@%@", baseURL(destination), path)
	}
	
	/// Convenient variable getting URL
	func url(_ placeholders: String.Placeholder = [:]) -> String {
		var fullpath = ""
		switch self {
		case .config:
			let currentVersion = "1.20.0"
			let path = self.rawValue.replacingOccurrences(of: "{version}", with: currentVersion)
			fullpath = RequestPath.createURL(destination: .config, path: path)
			
		case .refreshToken:
			fullpath = RequestPath.createURL(destination: .session, path: self.rawValue)
			
		case .playmedia:
			fullpath = AppConfiguration.shared.playbackURL
			
		default:
			let path = AppConfiguration.shared.rmsConfig(self.rawValue) ?? ""
			fullpath = RequestPath.createURL(path: path)
		}
		return fullpath.bbc.replace(placeholders)
	}
}
