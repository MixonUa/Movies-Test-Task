//
//  NetworkService.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any],
        headers: [String: String],
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class NetworkService: NetworkServiceProtocol {
    
    private let client: NetworkClientProtocol
    private let builder: RequestBuilderProtocol
    private let decoder: JSONDecoder
    
    init(
        client: NetworkClientProtocol = NetworkClient(),
        builder: RequestBuilderProtocol = RequestBuilder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.client = client
        self.builder = builder
        self.decoder = decoder
    }
    
    func fetchData<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        parameters: [String: Any] = [:],
        headers: [String: String] = [:],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        guard let request = builder.makeRequest(
            url: url,
            method: method,
            parameters: parameters,
            headers: headers
        ) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        client.performRequest(request) { [weak self] result in
            switch result {
            case .success(let data):
                guard let strongSelf = self else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.cancelled))
                    }
                    return
                }

                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let decoded = try strongSelf.decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(decoded))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(NetworkError.decodingError))
                        }
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

    }
}
