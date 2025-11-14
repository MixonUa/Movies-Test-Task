//
//  FavoriteMovieTableViewCell.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation
import UIKit

class FavoriteMovieTableViewCell: UITableViewCell {
    
    private let view = UIView()
    private let sv = UIStackView()
    let image = UIImageView()
    let title = UILabel()
    let yearLabel = UILabel()
    let voteLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        backgroundColor = .clear
        
        view.backgroundColor = Resources.Colors.tabBarUnselectTabColor
        addSubview(view)
        
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        view.addSubview(image)
        
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .leading
        sv.distribution = .fillEqually
        view.addSubview(sv)
        
        title.font = UIFont(name: "Helvetica-Bold", size: 24)
        title.textColor = Resources.Colors.standartTextColor
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth = true
        title.adjustsFontForContentSizeCategory = true
        view.addSubview(title)

        
        [yearLabel, voteLabel].forEach { label in
            label.font = UIFont(name: "Helvetica", size: 14)
            label.textColor = Resources.Colors.standartTextColor
            label.textAlignment = .left
            label.adjustsFontSizeToFitWidth = true
            label.adjustsFontForContentSizeCategory = true
            sv.addArrangedSubview(label)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.5)
        ])
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            title.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            sv.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12),
            sv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sv.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10)
        ])
    }
}
