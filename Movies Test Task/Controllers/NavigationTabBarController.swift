//
//  ViewController.swift
//  Movies Test Task
//
//  Created by Mixon on 12.11.2025.
//


import Foundation
import UIKit

class NavigationTabBarController: UITabBarController {
    private var moviesViewModel: MoviesListViewModel
    
    init(viewModel: MoviesListViewModel) {
        self.moviesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    private func setupViews() {
        tabBar.tintColor = Resources.Colors.standartTextColor
        tabBar.unselectedItemTintColor = Resources.Colors.tabBarUnselectTabColor
        tabBar.backgroundImage = UIImage()
        
        let moviesListNavigationController = NavigationController(rootViewController: FullListViewController(viewModel: moviesViewModel))
        let favoritesNavigationController = NavigationController(rootViewController: FavoritesViewController())

        moviesListNavigationController.tabBarItem = Tabs.moviesList.itemBar
        favoritesNavigationController.tabBarItem = Tabs.favorites.itemBar
        
        setViewControllers([moviesListNavigationController, favoritesNavigationController], animated: false)
        selectedIndex = Tabs.moviesList.rawValue
        
        let positionX: CGFloat = tabBar.bounds.width / 5
        let positionY: CGFloat = 8
        let width = tabBar.bounds.width - positionX * 2
        let height = tabBar.bounds.height + positionY * 2
        
        let round = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionX, y: tabBar.bounds.minY - positionY, width: width, height: height), cornerRadius: height / 3)
        
        round.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(round, at: 0)
        tabBar.itemWidth = width / 3
        tabBar.itemPositioning = .centered
        round.fillColor = Resources.Colors.tabBarColor.cgColor
    }
}
