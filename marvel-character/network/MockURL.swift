//
//  MockURL.swift
//  marvel-character
//
//  Created by Leyner Castillo on 27/07/21.
//

import Foundation

class MockURL: URLProtocol {

    static var stubs: [Stub] = [Stub]()

    override open class func canInit(with request: URLRequest) -> Bool {
        MockURL.stubForRequest(request) != nil
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override open func startLoading() {
        guard let stub = MockURL.stubForRequest(request) else {
            let error = NSError(domain: NSExceptionName.internalInconsistencyException.rawValue, code: 0, userInfo: [ NSLocalizedDescriptionKey: "No matching stub for request \(String(describing: request.url?.absoluteString))" ])
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        switch stub.response {
        case .success(let resourceInfo):
            let responseData = data(from: resourceInfo)
            if let delay = stub.delay {
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + delay) {
                    self.sendResponse(url: self.request.url!, statusCode: stub.statusCode, headerFields: self.request.allHTTPHeaderFields, data: responseData)
                }
            } else {
                self.sendResponse(url: request.url!, statusCode: stub.statusCode, headerFields: request.allHTTPHeaderFields, data: responseData)
            }
            
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override open func stopLoading() {

    }

    // MARK: - Helpers
    private func sendResponse(url: URL, statusCode: Int, headerFields: [String: String]?, data: Data) {
        print("🤖🤖🤖 Used stub for \(request.httpMethod!) \(String(describing: request.url?.absoluteString))")

        let httpResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: headerFields ?? [String: String]())
        client?.urlProtocol(self, didReceive: httpResponse!, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocol(self, didLoad: data)
        self.client?.urlProtocolDidFinishLoading(self)
    }

    private func data(from resourceInfo: ResourceInfo) -> Data {
        if let path = Bundle.main.path(forResource: resourceInfo.path, ofType: resourceInfo.type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                print("🚀 🤖 ❌ Invalid resource at \(path)")
                return Data()
            }
        }
        print("🚀 🤖 ❌ Cant Load resource at \(resourceInfo.path) with type \(resourceInfo.type)")
        return Data()
    }



    class func addStub(_ stub: Stub) {
        stubs.append(stub)
    }

    class func removeStub(_ stub: Stub) {
        if let index = stubs.firstIndex(of: stub) {
            stubs.remove(at: index)
        }
    }

    class func removeAllStubs() {
        stubs.removeAll(keepingCapacity: false)
    }

    class func stubForRequest(_ request: URLRequest) -> Stub? {
        for stub in stubs {
            if stub.match(request) {
                return stub
            }
        }

        return nil
    }
}
