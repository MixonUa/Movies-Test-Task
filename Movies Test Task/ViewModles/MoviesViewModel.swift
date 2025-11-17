//
//  MoviesListViewModel.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

struct LoadedImages{
    let name: String
    let image: UIImage
}

import Foundation
import Combine
import UIKit

class MoviesListViewModel {
    
    private var currentPage = 0
    private var totalPages = 0
    private var canLoad = true
    private let networkService: NetworkService
    public var imgArray: [LoadedImages] = []
      
    init() {
          self.networkService = NetworkService()
      }
    
    private var moviesSubject = CurrentValueSubject<[Movie], Never>([])
    var moviesPublisher: AnyPublisher<[Movie], Never> {
        return moviesSubject.eraseToAnyPublisher()
    }
    
    private var imagesUploaded = CurrentValueSubject<[LoadedImages], Never>([])
    var imagesPublisher: AnyPublisher<[LoadedImages], Never> {
        return imagesUploaded.eraseToAnyPublisher()
    }
    
    private var isLoadingPage = CurrentValueSubject<Bool, Never>(false)
    var loadingPublisher: AnyPublisher<Bool, Never> {
        return isLoadingPage.eraseToAnyPublisher()
    }
    
    private func getMoviesList(completion: @escaping (Result<MoviesList, Error>) -> Void) {
        let url = NetList.Urls.baseUrl + NetList.Points.popularMovies
        networkService.fetchData(url: url, parameters: NetList.Keys.parameters, completion: completion)
    }
    
    private func appendMovies(_ newMovies: [Movie]) {
        var currentMovies = moviesSubject.value
        currentMovies.append(contentsOf: newMovies)
        moviesSubject.send(currentMovies)
    }
    
    func fetchNextPage() {
        guard canLoad, currentPage < totalPages else { return }
        canLoad = false
        currentPage += 1
        getMoviesList(page: currentPage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieListResponse):
                appendMovies(movieListResponse.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
            canLoad = true
        }
    }
    
    private func loadImages(movies: [Movie]) {
        isLoadingPage.send(true)
        print(#function)
        for movie in movies {
            guard let url = URL(string: NetList.Urls.imageSmallUrl + movie.posterPath) else { return }
            ImageLoaderService.loadImage(from: url) { image in
                guard let image else { return }
                self.imgArray.append(LoadedImages(name: movie.title, image: image))
                
                if self.imgArray.count % 20 == 0 {
                    self.imagesUploaded.send(self.imgArray)
                    self.isLoadingPage.send(false)
                }
            }
        }
       
    }
    
    private func getMoviesList(page: Int, completion: @escaping (Result<MoviesList, Error>) -> Void) {
        var parameters = NetList.Keys.parameters
        parameters["page"] = page
        
        let url = NetList.Urls.baseUrl + NetList.Points.popularMovies
        networkService.fetchData(url: url, parameters: parameters, completion: completion)
    }
    
    func fetchData() {
        guard  canLoad else { return }
        canLoad = false
        getMoviesList { [weak self] result in
            switch result {
            case .success(let movieListResponse):
                self?.appendMovies(movieListResponse.results)
                self?.totalPages = movieListResponse.totalPages
                self?.currentPage = movieListResponse.page
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.canLoad = true
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
