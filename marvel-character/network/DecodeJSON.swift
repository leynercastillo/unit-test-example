//
//  DecodeJSON.swift
//  marvel-character
//
//  Created by Leyner Castillo on 27/07/21.
//

import Foundation

import Foundation

class DecodeJSON {

    /// Decode raw binary Data and converted to an inferred type.
    ///
    /// - Parameter data: raw binary Data
    /// - Returns: inferred type
    static func decode<T: Codable>(data: Data?) -> T? {
        do {
            guard let data = data else { return nil }
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)

            return result

        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            return nil

        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            print("[Decode JSON]  FAILED")
            return nil

        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            print("[Decode JSON]  FAILED")
            return nil

        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            print("[Decode JSON]  FAILED")
            return nil

        } catch {
            print("error: ", error)
            print("[Decode JSON]  FAILED")
            return nil
        }
    }
}
