//
//  ApiProvider.swift
//  Doggie
//
//  Created by Jose Galindo Martinez on 6/16/23.
//

import Foundation
import Network

class ApiProvider: ApiKeyProvider {
    var apiKey: String
    
    init() {
        #if DEBUG
        self.apiKey = ConstantsManager.shared.getAPIKey() ?? ""
        #else
        self.apiKey = ""
        #endif
    }
}
