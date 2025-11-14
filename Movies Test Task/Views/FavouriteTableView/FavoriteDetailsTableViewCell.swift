//
//  FavoriteDetailsTableViewCell.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation
import UIKit

class FavoriteDetailsTableViewCell: UITableViewCell {
    
    private let sv = UIStackView()
    let title = UILabel()
    let yearLabel = UILabel()
    let desc = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        backgroundColor = .clear
        
        title.font = UIFont(name: "Helvetica-Bold", size: 32)
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 2
        addSubview(title)
        
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        sv.alignment = .center
        addSubview(sv)
                
        yearLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        yearLabel.textAlignment = .center
        yearLabel.adjustsFontSizeToFitWidth = true
        sv.addArrangedSubview(yearLabel)
        
        desc.font = UIFont(name: "Helvetica-Light", size: 18)
        desc.textAlignment = .justified
        desc.numberOfLines = 0
        desc.textColor = Resources.Colors.standartTextColor
        addSubview(desc)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        desc.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            desc.topAnchor.constraint(equalTo: sv.bottomAnchor, constant: 20),
            desc.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            desc.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            desc.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
        ])
    }
}
