//
//  Environment.swift
//  marvel-character
//
//  Created by Leyner Castillo on 27/07/21.
//

import Foundation

struct Environment {
    enum VariableNames: String {
        case baseUrl = "BASE_URL"
        case apiKey = "API_KEY"
        case apiTS = "API_TS"
        case apiHash = "API_HASH"
    }

    static func getEnvironmentVariable(name: VariableNames) -> String? {
        let environmentDictionary = Bundle.main.infoDictionary!
        let variable = environmentDictionary[name.rawValue] as? String

        return variable
    }
}
