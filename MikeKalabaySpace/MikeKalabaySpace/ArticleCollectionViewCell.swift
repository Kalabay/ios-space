//
//  ArticleCollectionViewCell.swift
//  MikeKalabaySpace
//
//  Created by Mikhail Kalabai on 22.12.2023.
//

import Foundation
import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let updatedAtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private var imageUrlString: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(updatedAtLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            updatedAtLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            updatedAtLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            updatedAtLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            imageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: updatedAtLabel.bottomAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10) ])
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title

        if imageUrlString != article.image_url {
            imageUrlString = article.image_url
            imageView.image = nil

            if let imageUrl = URL(string: imageUrlString!) {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: imageUrl), self?.imageUrlString == article.image_url {
                        DispatchQueue.main.async {
                            self?.imageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }

        if let updatedAtDate = article.Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            updatedAtLabel.text = "Обновление: " + dateFormatter.string(from: updatedAtDate)
        }
    }
}
