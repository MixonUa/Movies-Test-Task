//
//  String + Extension.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation

extension String {
    
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "yyyy"
        
        return dateFormatter.string(from: date)
    }
}
