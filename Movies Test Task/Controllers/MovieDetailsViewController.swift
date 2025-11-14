//
//  MovieDetailsVC.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation
import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
    private let viewModel = MoviesListViewModel()
    private let favoritViewModel = FavoriteViewModel()
    private var favoriteMovies: [MovieModel] = []
    private var movie: Movie?
    private var cancellables = Set<AnyCancellable>()
    
    private var backButton: UIButton!
    private var favouriteButton: UIButton!
    private var tableView: UITableView!
    private var tableViewHeader: DetailsHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        
        favoritViewModel.moviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                guard let self = self else { return }
                self.favoriteMovies = movies
                self.updateFavourite()
            }
            .store(in: &cancellables)
    }
    
    func updateFavourite() {
        let sameMovie = favoriteMovies.filter{$0.title == self.movie?.title}
        if sameMovie.count > 0 {
            favouriteButton.setImage(Resources.Images.favouriteFilled, for: .normal)
        } else {
            favouriteButton.setImage(Resources.Images.favouriteClear, for: .normal)
        }
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addToFavourite() {
        guard let selectedMovie = movie else { return }
        viewModel.checkMovie(selectedMovie)
    }

// MARK: - ViewConfiguration
    private func setupView() {
        view.backgroundColor = Resources.Colors.mainBackgroundColor
        
        tableView = UITableView()
        view.addSubview(tableView)
        
        backButton = UIButton()
        backButton.setImage(Resources.Images.back, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(backButton)
        
        favouriteButton = UIButton()
        favouriteButton.setImage(Resources.Images.favouriteClear, for: .normal)
        favouriteButton.addTarget(self, action: #selector(addToFavourite), for: .touchUpInside)
        view.addSubview(favouriteButton)
        
        let width = view.frame.size.width
        tableViewHeader = DetailsHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: width * 1.5))
        
        if let posterPath = movie?.posterPath,
           let url = URL(string: NetList.Urls.imageBaseUrl + posterPath) {
            tableViewHeader.imageView.loadImage(from: url, placeholder: Resources.Images.defaultImage)
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
        
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favouriteButton.widthAnchor.constraint(equalToConstant: 60),
            favouriteButton.heightAnchor.constraint(equalToConstant: 60),
            favouriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            favouriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
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
extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "DetailsTableViewCell")
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as? DetailsTableViewCell,
              let movie = movie else {
            return UITableViewCell()
        }
        
        cell.title.text = movie.title
        cell.yearLabel.text = movie.releaseDate.getYear()
        cell.voteLabel.text = movie.voteAverage.description
        cell.descr.text = movie.overview
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableViewHeader = tableView.tableHeaderView as? DetailsHeaderView else { return }
        tableViewHeader.didScroll(scrollView: tableView)
    }
}

// MARK: - Delegate
extension MovieDetailsViewController: MovieDelegate {
    func didSelectMovie(_ movie: Movie) {
        self.movie = movie
    }
}
