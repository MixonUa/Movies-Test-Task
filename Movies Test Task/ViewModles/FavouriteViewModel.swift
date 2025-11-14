//
//  FavouriteViewModel.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//


import Foundation
import Combine

class FavoriteViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private let moviesSubject = CurrentValueSubject<[MovieModel], Never>([])
    
    var moviesPublisher: AnyPublisher<[MovieModel], Never> {
        return moviesSubject.eraseToAnyPublisher()
    }
    
    init() {
        CoreDataService.shared.moviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.moviesSubject.send(movies)
            }
            .store(in: &cancellables)
    }
    
    func getFavoriteMoviesList() -> [MovieModel] {
        return moviesSubject.value
    }
    
    func deleteFromFavorite(_ movie: MovieModel) {
        DBService.removeObject(movie)
    }
}
