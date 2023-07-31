//
//  ConstantManager.swift
//  Doggie
//
//  Created by Jose Galindo Martinez on 6/16/23.
//

import Foundation

final class ConstantsManager {
    static let shared = ConstantsManager()
    private var dictionary: [String: Any]!
    
    private init() {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            return
        }
        if let plist = NSDictionary(contentsOfFile: path) as? [String: Any] {
            dictionary = plist
        }
    }
    
    func getBasePath() -> String? {
        return dictionary[Constants.kBasePath] as? String
    }
    
    func getAPIKey() -> String? {
        return dictionary[Constants.kApiKey] as? String
    }
}

struct Constants {
    static let kBasePath = "BASE_PATH"
    static let kApiKey = "API_KEY"
}
