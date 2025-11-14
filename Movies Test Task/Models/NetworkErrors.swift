//
//  NetworkErrors.swift
//  Movies Test Task
//
//  Created by Mixon on 14.11.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Wrong URL"
        case .invalidResponse:
            return "Wrong response"
        }
    }
}
