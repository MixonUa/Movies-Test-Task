//
//  NetworkErrors.swift
//  Movies Test Task
//
//  Created by Mixon on 14.11.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case cancelled
    case badResponse
    case noData
    case decodingError
    
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Wrong URL"
        case .cancelled:
            return "cancelled"
        case .badResponse:
            return "Bad response"
        case .noData:
            return "No data"
        case .decodingError:
            return "Decoding error"
        }
    }
}
