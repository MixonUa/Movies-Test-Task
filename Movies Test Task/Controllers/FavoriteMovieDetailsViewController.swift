//
//  FavoriteMovieDetailsViewController.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation
import UIKit

class FavoriteMovieDetailsViewController: UIViewController {
    private var movie: MovieModel?
    
    private var backButton: UIButton!
    private var tableView: UITableView!
    private var tableViewHeader: DetailsHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
// MARK: - ViewConfiguration
        private func setupView() {
            
            view.backgroundColor = Resources.Colors.mainBackgroundColor
            
            tableView = UITableView()
            view.addSubview(tableView)
            
            backButton = UIButton(type: .system)
            backButton.setImage(UIImage(named: "backButton"), for: .normal)
            backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
            backButton.tintColor = Resources.Colors.standartTextColor
            view.addSubview(backButton)
            
            let width = view.frame.size.width
            tableViewHeader = DetailsHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: width * 1.5))
            
            if let posterPath = movie?.posterPathData {
                tableViewHeader.imageView.image = UIImage(data: posterPath)
            } else {
                tableViewHeader.imageView.image = Resources.Images.defaultImage
            }
            
            tableView.tableHeaderView = tableViewHeader
            
            backButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backButton.widthAnchor.constraint(equalToConstant: 60),
                backButton.heightAnchor.constraint(equalToConstant: 60),
                backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
                backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
            ])
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
// MARK: - UITableViewDelegate & DataSource
extension FavoriteMovieDetailsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteDetailsTableViewCell.self, forCellReuseIdentifier: "FavoriteDetailsTableViewCell")
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteDetailsTableViewCell", for: indexPath) as? FavoriteDetailsTableViewCell,
              let movie = movie else {
            return UITableViewCell()
        }
        
        cell.title.text = movie.title
        cell.yearLabel.text = movie.releaseDate.getYear()
        cell.desc.text = movie.overview
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableViewHeader = tableView.tableHeaderView as? DetailsHeaderView else { return }
        tableViewHeader.didScroll(scrollView: tableView)
    }
}
// MARK: - Delegate
extension FavoriteMovieDetailsViewController: FavoriteDelegate {
    func didSelectFavoriteMovie(_ movie: MovieModel) {
        self.movie = movie
    }
}
