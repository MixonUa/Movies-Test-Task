//
//  MovieModel.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation

struct MoviesList: Codable {
    let results: [Movie]
    let page, totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

struct Movie: Codable {
    let id: Int
    let title, overview: String
    let posterPath, releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

struct MovieModel: Codable, Identifiable {
    var id: Int
    var title: String
    var overview: String
    var posterPathData: Data?
    var releaseDate: String
    var voteAverage: Double
    
    init(id: Int, title: String, overview: String, posterPathData: Data?, releaseDate: String, voteAverage: Double) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPathData = posterPathData
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }
}
