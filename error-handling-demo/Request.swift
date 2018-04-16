//
//  Request.swift
//  error-handling-demo
//
//  Created by Sinan Eren on 4/16/18.
//

import Foundation

enum Request {
    case database
    static let baseURL = "https://functional-error-handling-demo.firebaseio.com/"
}

fileprivate enum RequestType: String {
    case get = "GET"
}

private protocol EndpointDescriptive {
    var endpoint: String { get }
}

extension Request: EndpointDescriptive {

    var endpoint: String {
        return ".json"
    }
}

extension Request {

    fileprivate var requestType: RequestType {
        return .get
    }

    var urlString: String {
        return Request.baseURL + endpoint
    }

    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        return urlRequest
    }
}
