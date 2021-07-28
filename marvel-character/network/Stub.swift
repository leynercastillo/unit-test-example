//
//  Stub.swift
//  marvel-character
//
//  Created by Leyner Castillo on 27/07/21.
//

import Foundation
import Alamofire

typealias ResourceInfo = (path: String, type: String)

class Stub: Equatable {

    var method: HTTPMethod
    var urlString: String
    var response: Result<ResourceInfo, Error>
    var delay: TimeInterval?
    var statusCode: Int

    init(method: HTTPMethod, urlString: String, statusCode: Int, response: Result<ResourceInfo, Error>) {
        self.method = method
        self.urlString = urlString
        self.response = response
        self.statusCode = statusCode
    }

    static func == (lhs: Stub, rhs: Stub) -> Bool {
        lhs.method == rhs.method && lhs.urlString == rhs.urlString
    }

    func match(_ urlRequest: URLRequest) -> Bool {
        if self.method.rawValue == urlRequest.httpMethod
            && self.urlString == urlRequest.url?.absoluteString {
            return true
        }

        return false
    }
}
