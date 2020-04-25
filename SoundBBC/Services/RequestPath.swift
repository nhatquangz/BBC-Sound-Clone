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
}



extension RequestPath {
	var rmiurl: String {
		let baseURL = AppEnvironment.shared.current.rmsURL
		let path = AppConfiguration.shared.rmsConfig?[self.rawValue].stringValue ?? ""
		return String(format: "%@/%@", baseURL, path)
	}
}
