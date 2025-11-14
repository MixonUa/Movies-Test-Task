//
//  FavoritesViewController.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import UIKit
import Combine

protocol FavoriteDelegate: AnyObject {
    func didSelectFavoriteMovie(_ movie: MovieModel)
}

class FavoritesViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = FavoriteViewModel()
    
    private var favoriteMovies: [MovieModel] = []
    
    weak var delegateFavoriteMovie: FavoriteDelegate?
    
    private let label = UILabel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        
        viewModel.moviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                guard let self = self else { return }
                self.favoriteMovies = movies
                self.updateUI()

            }
            .store(in: &cancellables)
    }
    
    private func updateUI() {
        if favoriteMovies.isEmpty {
            tableView.isHidden = true
            label.isHidden = false
        } else {
            tableView.isHidden = false
            label.isHidden = true
            tableView.reloadData()
        }
    }
// MARK: - ViewConfiguration
    private func setupView() {
        view.backgroundColor = Resources.Colors.mainBackgroundColor
        
        label.text = Resources.Texts.addMovie
        label.font = UIFont(name: "Helvetica-Bold", size: 36)
        label.textColor = Resources.Colors.standartTextColor
        label.textAlignment = .center
        label.numberOfLines = 2
        label.alpha = 0.1
        label.isHidden = true
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6)
        ])
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FavoriteMovieTableViewCell.self, forCellReuseIdentifier: "FavoriteMovieTableViewCell")
        view.addSubview(tableView)
        
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
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieTableViewCell", for: indexPath) as? FavoriteMovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = favoriteMovies[indexPath.row]
        
        if let imageData = movie.posterPathData, let image = UIImage(data: imageData) {
            cell.image.image = image
        } else {
            cell.image.image = Resources.Images.defaultImage
        }
        
        cell.title.text = movie.title
        cell.voteLabel.text = "\(Resources.Texts.voteText): \(movie.voteAverage)"
        cell.yearLabel.text = "\(Resources.Texts.yearText): \(String(describing: movie.releaseDate.getYear()))"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = favoriteMovies[indexPath.row]
        let vc = FavoriteMovieDetailsViewController()
        delegateFavoriteMovie = vc
        navigationController?.pushViewController(vc, animated: true)
        delegateFavoriteMovie?.didSelectFavoriteMovie(movie)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { _,_,done in
            let movie = self.favoriteMovies[indexPath.item]
            
            tableView.performBatchUpdates({
                self.favoriteMovies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            }) { _ in
                self.viewModel.deleteFromFavorite(movie)
            }
        }
        
        delete.backgroundColor = .systemGroupedBackground
        delete.image = UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
