//
//  DBService.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation

class DBService {
    
    static func addObject(object: MovieModel) {
        CoreDataService.shared.addObject(object)
    }
    
    static func getObjects() -> [MovieModel] {
        return CoreDataService.shared.getObjects()
    }
    
    static func removeObject(_ object: MovieModel) {
        CoreDataService.shared.removeObject(object)
    }
}
