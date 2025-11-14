//
//  MoviesListViewModel.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation
import Combine

class MoviesListViewModel {
    
    private var currentPage = 0
    private var totalPages = 0
    
    private var moviesSubject = CurrentValueSubject<[Movie], Never>([])
    var moviesPublisher: AnyPublisher<[Movie], Never> {
        return moviesSubject.eraseToAnyPublisher()
    }
    
    
    private func getMoviesList(completion: @escaping (Result<MoviesList, Error>) -> Void) {
        let url = NetList.Urls.baseUrl + NetList.Points.popularMovies
        NetworkService.fetchData(url: url, parameters: NetList.Keys.parameters, completion: completion)
    }
    
    private func appendMovies(_ newMovies: [Movie]) {
        var currentMovies = moviesSubject.value
        currentMovies.append(contentsOf: newMovies)
        moviesSubject.send(currentMovies)
    }
    
    func fetchNextPage() {
        guard currentPage < totalPages else { return }
        
        currentPage += 1
        getMoviesList(page: currentPage) { [weak self] result in
            switch result {
            case .success(let movieListResponse):
                self?.appendMovies(movieListResponse.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getMoviesList(page: Int, completion: @escaping (Result<MoviesList, Error>) -> Void) {
        var parameters = NetList.Keys.parameters
        parameters["page"] = page
        
        let url = NetList.Urls.baseUrl + NetList.Points.popularMovies
        NetworkService.fetchData(url: url, parameters: parameters, completion: completion)
    }
    
    func fetchData() {
        getMoviesList { [weak self] result in
            switch result {
            case .success(let movieListResponse):
                self?.appendMovies(movieListResponse.results)
                self?.totalPages = movieListResponse.totalPages
                self?.currentPage = movieListResponse.page
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func checkMovie(_ movie: Movie) {
        guard let movieFroDB = DBService.getObjects().first(where: { $0.id == movie.id} ) else {
            addToFavorite(from: movie)
            return
        }
        DBService.removeObject(movieFroDB)
    }
    
    private func addToFavorite(from movie: Movie) {
        let movieDB = MovieModel(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterPathData: nil,
            releaseDate: movie.releaseDate,
            voteAverage: movie.voteAverage
        )
        
        guard let posterPathURL = URL(string: NetList.Urls.imageBaseUrl + movie.posterPath) else {
            DBService.addObject(object: movieDB)
            return
        }
        
        ImageLoaderService.loadImageData(from: posterPathURL) { imageData in
            var updatedMovieDB = movieDB
            updatedMovieDB.posterPathData = imageData
            DBService.addObject(object: updatedMovieDB)
        }
    }
}
