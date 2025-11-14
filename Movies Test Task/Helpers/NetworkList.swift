//
//  NetworkList.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation

struct NetList {
    
    struct Urls {
        static let baseUrl = "https://api.themoviedb.org"
        static let imageBaseUrl = "https://image.tmdb.org/t/p/original"
    }
    
    struct Points {
        static let popularMovies = "/3/movie/popular"
    }
    
    struct Keys {
        static let apiKey = "2ccc9fcb3e886fcb5f80015418735095"
        static let parameters: [String: Any] = ["api_key": NetList.Keys.apiKey]
    }
}
