//
//  JSONFileHelper.swift
//  MessagingClient
//
//  Created by Jamie Kelly on 10/11/2024.
//

import UIKit

//From a previous side project so I didn't write this specifically for the task, just
//to save a bit of time loading the dummy JSON.


class JSONFileHelper {

    class func json(fromFileInBundleWithName filename: String) -> [JSON]? {
        let url = URL(string: filename)
        let pathExtension = url?.pathExtension ?? ""
        let ext = pathExtension.isEmpty ? "json" : pathExtension
        let filenameWithNoExtension = url?.deletingPathExtension().lastPathComponent
        guard let name = filenameWithNoExtension else {
            return nil
        }
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: ext) else {
            return nil
        }
        return json(fromFileWithPath: bundleURL.path)
    }
 
    
    class func json(fromFileWithPath path: String) -> [JSON]? {
        do {
            let url = URL(fileURLWithPath: path)
            let jsonData = try Data(contentsOf: url, options: .mappedIfSafe)
            if let result = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [JSON] {
                return result
            }
        }
        catch {
            return nil
        }
        return nil
    }
}
