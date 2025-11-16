//
//  NetworkClient.swift
//  Movies Test Task
//
//  Created by Mixon on 16.11.2025.
//

import Foundation

protocol NetworkClientProtocol {
    func performRequest(
        _ request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

final class NetworkClient: NetworkClientProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func performRequest(
        _ request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                200...299 ~= httpResponse.statusCode
            else {
                DispatchQueue.main.async { completion(.failure(NetworkError.badResponse)) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NetworkError.noData)) }
                return
            }
            
            DispatchQueue.main.async { completion(.success(data)) }
            
        }.resume()
    }
}
