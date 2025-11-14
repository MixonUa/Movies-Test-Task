//
//  Resources.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation
import UIKit

struct Resources {
    
    struct Colors {
        static let mainBackgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
        static let tabBarColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        static let tabBarUnselectTabColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        static let standartTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    struct Images {
        static let cup = UIImage(named: "loadCup")
        static let popсorn = UIImage(named: "loadPopсorn")
        static let glasses = UIImage(named: "loadingGlasses")
        static let defaultImage = UIImage(named: "post")
        static let back = UIImage(named: "backButton")
        static let favouriteClear = UIImage(named: "heartClear")
        static let favouriteFilled = UIImage(named: "heartFill")
    }
    
    struct Texts {
        static let yearText = "Year"
        static let voteText = "Vote"
        static let addMovie = "Add your favorite movie"
    }
}
