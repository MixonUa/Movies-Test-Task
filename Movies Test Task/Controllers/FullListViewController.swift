//
//  FullListViewController.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation
import UIKit
import Combine

protocol MovieDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
}

class FullListViewController: UIViewController {
    
    private var viewModel: MoviesListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    weak var delegateMovie: MovieDelegate?
    
    private var collectionView: UICollectionView!
    
    var list: [Movie] = []
    
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Resources.Colors.mainBackgroundColor
        setupCollectionView()

        viewModel.moviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] moviesList in
                guard let self = self else { return }
                self.list = moviesList
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
// MARK: - ViewConfiguration
    private func setupCollectionView() {
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.minimumLineSpacing = 8
                layout.minimumInteritemSpacing = 8
                
                collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                collectionView.backgroundColor = .clear
                collectionView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(collectionView)
                NSLayoutConstraint.activate([
                    collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.backgroundColor = .clear
    }
}
// MARK: - UICollectionViewDelegate & DataSource
extension FullListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath as IndexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.label.text = list[indexPath.row].title
        
        if let url = URL(string: NetList.Urls.imageBaseUrl + list[indexPath.row].posterPath) {
            cell.image.loadImage(from: url, placeholder: Resources.Images.defaultImage)
        } else {
            cell.image.image = Resources.Images.defaultImage
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = list[indexPath.row]
        let vc = MovieDetailsViewController()
        delegateMovie = vc 
        navigationController?.pushViewController(vc, animated: true)
        delegateMovie?.didSelectMovie(movie)
    }
}
// MARK: - CollectionView Flow Layout
extension FullListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 4
        let collectionViewWidth = collectionView.frame.width
        let cellWidth = (collectionViewWidth - 3 * spacing) / 2.0
        
        return CGSize(width: cellWidth, height: cellWidth * 1.7)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height
        
        if offsetY > contentHeight {
            viewModel.fetchNextPage()
        }
    }
}
