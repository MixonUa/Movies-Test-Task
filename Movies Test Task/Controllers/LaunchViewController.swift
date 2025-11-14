//
//  LaunchViewController.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation
import UIKit
import Combine

class LaunchViewController: UIViewController {
    private let moviesViewModel = MoviesListViewModel()

    private let screenBounds = UIScreen.main.bounds
    private let loadingLeft = UIImageView(image: Resources.Images.cup)
    private let loadingRight = UIImageView(image: Resources.Images.popсorn)
    private let loadingMiddle = UIImageView(image: Resources.Images.glasses)
    private let loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        moviesViewModel.fetchData()
        
        configureLoadingImages()
        configureLoadingLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animateKeyframes(withDuration: 3.0, delay: 0.5, options: .calculationModeLinear, animations: { [self] in
            loadingRight.frame.origin.x = screenBounds.width*0.26
            loadingLeft.frame.origin.x = screenBounds.width*0.44
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.8) { [unowned self] in
                loadingRight.alpha = 1
                loadingLeft.alpha = 1
                loadingLabel.alpha = 1
            }
        }, completion: { [self] _ in
            presentMainVC()
        })
    }
// MARK: - ViewConfiguration
    private func configureLoadingImages() {
        loadingLeft.contentMode = .scaleAspectFit
        loadingLeft.alpha = 0.1
        loadingLeft.frame = CGRect(x: (-screenBounds.width*0.3), y: (screenBounds.height*0.3), width: screenBounds.width*0.3, height: screenBounds.height*0.3)
        view.addSubview(loadingLeft)
        
        loadingRight.contentMode = .scaleAspectFit
        loadingRight.alpha = 0.1
        loadingRight.frame = CGRect(x: screenBounds.width, y: (screenBounds.height*0.3), width: screenBounds.width*0.3, height: screenBounds.height*0.3)
        view.addSubview(loadingRight)
    }
    
    private func configureLoadingLabel() {
        loadingLabel.text = "Best movies here!"
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont(name: "Noteworthy", size: 30)
        loadingLabel.alpha = 0
        loadingLabel.frame = CGRect(x: 0, y: screenBounds.height*0.56, width: screenBounds.width, height: 60)
        view.addSubview(loadingLabel)
    }
// MARK: - Navigation
    private func presentMainVC() {
        let vc = NavigationTabBarController(viewModel: self.moviesViewModel)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = scene.windows.first {
                UIView.transition(with: window, duration: 0.6, options: .transitionCrossDissolve, animations: {
                    if let previousController = window.rootViewController {
                        previousController.dismiss(animated: false, completion: nil)
                    }
                    vc.modalPresentationStyle = .fullScreen
                    window.rootViewController = vc
                }, completion: nil)
            }
        }
    }
}
