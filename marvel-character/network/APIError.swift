//
//  APIError.swift
//  marvel-character
//
//  Created by Leyner Castillo on 27/07/21.
//

import Foundation

struct ApiError: Error {

    var title: String?
    var code: Int
    var dataError: ErrorDataModel?
    var errorDescription: String { return _description }

    private var _description: String

    init(title: String?, description: String, code: Int, dataError: ErrorDataModel?) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
        self.dataError = dataError
    }

    static func genericError() -> ApiError {
        ApiError(title: "ERROR", description: "An error has happened", code: -9999, dataError: nil)
    }
}
