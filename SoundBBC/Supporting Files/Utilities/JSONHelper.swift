//
//  JSONHelper.swift
//  SoundBBC
//
//  Created by nhatquangz on 4/25/20.
//  Copyright © 2020 nhatquangz. All rights reserved.
//

import Foundation

/**
Extension to save/load a JSON object by filename. (".json" extension is assumed and automatically added.)
 */
extension JSONSerialization {
    
    static func loadJSON(withFilename filename: String) throws -> Any? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
            return jsonObject
        }
        return nil
    }
    
    static func save(jsonObject: Any, toFilename filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        
        return false
    }
}
