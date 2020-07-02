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
	
	case refreshToken = "/tokens"
	case config = "/ios/{version}/config.json"
	
	enum Destination {
		case rms, config, session
	}
}



extension RequestPath {
	static func baseURL(_ destination: Destination) -> String {
		switch destination {
		case .rms:
			return AppConfiguration.shared.rmsConfig(path: "rootUrl") ?? ""
			
		case .config:
			return "https://sounds-mobile-config.files.bbci.co.uk"
			
		case .session:
			return "https://session.bbc.co.uk/session"
		}
	}
	
	
	/// Convenient variable getting URL
	var url: String {
		switch self {
		case .config:
			let currentVersion = "1.17.2"
			let path = self.rawValue.replacingOccurrences(of: "{version}", with: currentVersion)
			return RequestPath.createURL(destination: .config, path: path)
			
		case .refreshToken:
			return RequestPath.createURL(destination: .session, path: self.rawValue)
			
		default:
			let path = AppConfiguration.shared.rmsConfig(path: self.rawValue) ?? ""
			return RequestPath.createURL(path: path)
		}
	}
	
	
	static func createURL(destination: RequestPath.Destination = .rms, path: String) -> String {
		return String(format: "%@%@", baseURL(destination), path)
	}
}
