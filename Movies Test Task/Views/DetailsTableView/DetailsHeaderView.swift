//
//  DetailsView.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import UIKit

class DetailsHeaderView: UIView {
    
    let imageView = UIImageView()
    private let contentView = UIView()
    
    private var imageHeight = NSLayoutConstraint()
    private var imageBottom = NSLayoutConstraint()
    private var contentViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setupView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: contentView.widthAnchor),
            centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
        contentView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        contentViewHeight = contentView.heightAnchor.constraint(equalTo: self.heightAnchor)
        contentViewHeight.isActive = true
        
        imageBottom = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        imageBottom.isActive = true
        imageHeight = imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        imageHeight.isActive = true
    }
    
    public func didScroll(scrollView: UIScrollView) {
        contentViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        contentView.clipsToBounds = offsetY <= 0
        imageBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
