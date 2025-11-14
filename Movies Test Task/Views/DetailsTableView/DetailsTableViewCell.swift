//
//  DetailsTableViewCell.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell {
    private let sv = UIStackView()
    private let descrSV = UIStackView()
    var title = UILabel()
    var yearLabel = UILabel()
    var voteLabel = UILabel()
    var descr = UILabel()
    
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
        
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 8
        sv.alignment = .center
        addSubview(sv)
        
        [yearLabel, voteLabel].forEach { label in
            label.font = UIFont(name: "Helvetica-Bold", size: 24)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            sv.addArrangedSubview(label)
        }
        
        descrSV.axis = .horizontal
        descrSV.distribution = .fillEqually
        descrSV.spacing = 8
        descrSV.alignment = .center
        addSubview(descrSV)
        
        [Resources.Texts.yearText, Resources.Texts.voteText].forEach { text in
            let label = UILabel()
            label.text = text
            label.font = UIFont(name: "Helvetica", size: 14)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            descrSV.addArrangedSubview(label)
        }
        
        descr = UILabel()
        descr.font = UIFont(name: "Helvetica-Light", size: 18)
        descr.textAlignment = .justified
        descr.numberOfLines = 0
        addSubview(descr)
        
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
        
        descrSV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descrSV.topAnchor.constraint(equalTo: sv.bottomAnchor, constant: 8),
            descrSV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descrSV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        descr.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descr.topAnchor.constraint(equalTo: descrSV.bottomAnchor, constant: 20),
            descr.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descr.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            descr.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
        ])
    }
}
