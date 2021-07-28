//
//  CharacterRouter.swift
//  marvel-character
//
//  Created by Leyner Castillo on 27/07/21.
//

import Foundation

enum CharacterRouter: NetworkRouter {

    case characterList

    var path: String {
        switch self {
        case .characterList:
            return "/v1/public/characters"
        }
    }

}
