//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by v.milchakova on 16.12.2020.
//  Copyright © 2020 Artem Novichkov. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .gray
        spinner.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        return spinner
    }()
    
    private lazy var photoImage: UIImageView = {
        let photoImage = UIImageView()
        photoImage.toAutoLayout()
        photoImage.contentMode = .scaleAspectFit
        return photoImage
    }()
    
    public var imageUrl: String? {
        didSet {
            photoImage.image = nil
            updateUIUrl()
        }
    }
    
    private func updateUIUrl() {
        if let url = imageUrl {
            addSubview(spinner)
            spinner.startAnimating()
            let task = URLSession.shared.downloadTask(with: URL(string: url)!) { localURL, urlResponse, error in
                guard let url = localURL, let image = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async { [weak self] in
                        self?.photoImage.image = UIImage(data: image)
                        self?.photoImage.contentMode = .scaleToFill
                        print("Download OK")
                        self?.spinner.stopAnimating()
                    }
                }
            task.resume()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(contentView)
        contentView.addSubview(photoImage)
        
        NSLayoutConstraint.activate([
//            contentView.topAnchor.constraint(equalTo: topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            photoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
