//
//  RequestBuilder.swift
//  Movies Test Task
//
//  Created by Mixon on 16.11.2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol RequestBuilderProtocol {
    func makeRequest(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any],
        headers: [String: String]
    ) -> URLRequest?
}

class RequestBuilder: RequestBuilderProtocol {
    func makeRequest(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any],
        headers: [String: String]
    ) -> URLRequest? {
        
        guard var components = URLComponents(string: url) else { return nil }
        
        if method == .get {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let finalURL = components.url else { return nil }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
}
