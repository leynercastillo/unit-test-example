//
//  APIClient.swift
//  marvel-character
//
//  Created by Leyner Castillo on 27/07/21.
//

import Alamofire

class ApiClient {

    private var session: Session

    init() {
        let configuration = URLSessionConfiguration.default
        #if DEBUG
        configuration.protocolClasses?.insert(MockURL.self, at: 0)
        #endif
        session = Session(configuration: configuration)
    }

    // MARK: - Functions
    func request<T: Codable>(router: NetworkRouter, type: T.Type, completion: @escaping (Result<T?, ApiError>) -> Void) {

        session.request(router).responseData { response in

            switch response.result {
            case .success(let data):

                #if DEBUG
                print("✅✅✅DEBUG")
                try? print("URL " + router.asURL().absoluteString)
                print("METHOD " + router.method.rawValue)
                if let headers = try? JSONSerialization.data(withJSONObject: response.request?.allHTTPHeaderFields, options: .prettyPrinted) {
                    print("HEADERS " + String(data: headers, encoding: .utf8 )!)
                }
                if let parameters = router.parameters, let parametersData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
                    print("PARAMETERS " + String(data: parametersData, encoding: .utf8 )!)
                }
                if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let responseData = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted) {
                    print("RESPONSE " + String(data: responseData, encoding: .utf8 )!)
                }
                #endif

                if let code = response.response?.statusCode, (200...300).contains(code) {
                    let object: T? = DecodeJSON.decode(data: data)
                    completion(.success(object))

                } else {
                    guard let errorResponse: ErrorDataModel = DecodeJSON.decode(data: data) else { return }
                    let dataError = ApiError(title: "",
                                             description: errorResponse.status,
                                             code: response.response?.statusCode ?? 400,
                                             dataError: nil)
                    completion(.failure(dataError))
                }

            case .failure(let error):
                #if DEBUG
                print("❌❌❌ DEBUG")
                try? print("URL " + router.asURL().absoluteString)
                print("METHOD " + router.method.rawValue)
                if let headers = try? JSONSerialization.data(withJSONObject: response.request?.allHTTPHeaderFields, options: .prettyPrinted) {
                    print("HEADERS " + String(data: headers, encoding: .utf8 )!)
                }
                if let parameters = router.parameters, let parametersData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
                    print("PARAMETERS " + String(data: parametersData, encoding: .utf8 )!)
                }
                print("RESPONSE ERROR: \(error)")
                #endif

                completion(.failure(ApiError.genericError()))
            }
        }
    }
}
