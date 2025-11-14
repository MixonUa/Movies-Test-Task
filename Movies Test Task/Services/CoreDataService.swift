//
//  CoreDataService.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation
import UIKit
import CoreData
import Combine

class CoreDataService: NSObject {
    
    static let shared = CoreDataService()
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    private var fetchedResultsController: NSFetchedResultsController<MovieEntity>?
    private let moviesSubject = CurrentValueSubject<[MovieModel], Never>([])
    var moviesPublisher: AnyPublisher<[MovieModel], Never> {
        return moviesSubject.eraseToAnyPublisher()
    }
    
    private override init() {
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
            updateMoviesSubject()
        } catch {
            print("Error performing fetch: \(error.localizedDescription)")
        }
        
        NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: context,
            queue: .main
        ) { [weak self] _ in
            self?.updateMoviesSubject()
        }
    }
    
    private func updateMoviesSubject() {
        let movies = getObjects()
        moviesSubject.send(movies)
    }
    
    func addObject(_ movie: MovieModel) {
        let context = self.context
        
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        
        do {
            let existingMovies = try context.fetch(fetchRequest)
            
            let movieEntity: MovieEntity
            if let existing = existingMovies.first {
                movieEntity = existing
            } else {
                movieEntity = MovieEntity(context: context)
            }
            
            movieEntity.id = Int64(movie.id)
            movieEntity.title = movie.title
            movieEntity.overview = movie.overview
            movieEntity.posterPathData = movie.posterPathData
            movieEntity.releaseDate = movie.releaseDate
            movieEntity.voteAverage = movie.voteAverage
           
            
            try context.save()
        } catch {
            print("Error saving movie: \(error.localizedDescription)")
        }
    }
    
    func getObjects() -> [MovieModel] {
        let context = self.context
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let movieEntities = try context.fetch(fetchRequest)
            return movieEntities.map { entity in
                return MovieModel(
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    overview: entity.overview ?? "",
                    posterPathData: entity.posterPathData,
                    releaseDate: entity.releaseDate ?? "",
                    voteAverage: entity.voteAverage
                )
            }
        } catch {
            print("Error fetching movies: \(error.localizedDescription)")
            return []
        }
    }
    
    func removeObject(_ movie: MovieModel) {
        let context = self.context
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        
        do {
            let movies = try context.fetch(fetchRequest)
            movies.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Error deleting movie: \(error.localizedDescription)")
        }
    }
}

extension CoreDataService: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMoviesSubject()
    }
}
