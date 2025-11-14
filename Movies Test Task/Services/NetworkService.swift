//
//  NetworkService.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation

class NetworkService {

    static func fetchData<T: Codable>(url: String, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }

        guard let finalURL = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

