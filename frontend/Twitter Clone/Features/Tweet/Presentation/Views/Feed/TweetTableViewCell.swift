//
//  TweetTableViewCell.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import UIKit
import Kingfisher

final class TweetTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TweetTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 27.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let handleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let tweetLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let tweetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .red
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let imageHeightConstraint: NSLayoutConstraint
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.imageHeightConstraint = imageContainerView.heightAnchor.constraint(equalToConstant: 0)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = nil
        handleLabel.text = nil
        tweetLabel.text = nil
        errorLabel.text = nil
        errorLabel.isHidden = true
        tweetImageView.image = nil
        tweetImageView.alpha = 1
        imageHeightConstraint.constant = 0
        tweetImageView.kf.cancelDownloadTask()
    }
    
    private func setupUI() {
        let headerStack = UIStackView(arrangedSubviews: [nameLabel, handleLabel])
        headerStack.axis = .vertical
        headerStack.alignment = .leading
        headerStack.spacing = 2
        
        imageContainerView.addSubview(tweetImageView)
        imageContainerView.addSubview(errorLabel)

        let textStack = UIStackView(arrangedSubviews: [headerStack, tweetLabel])
        textStack.axis = .vertical
        textStack.alignment = .fill
        textStack.spacing = 12
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        let commentImage = makeActionIcon(systemName: "message")
        let retweetImage = makeActionIcon(systemName: "arrow.2.squarepath")
        let likeImage = makeActionIcon(systemName: "heart")
        let shareImage = makeActionIcon(systemName: "square.and.arrow.up")
        
        [commentImage, retweetImage, likeImage, shareImage].forEach {
            actionStack.addArrangedSubview($0)
        }
        
        let contentStack = UIStackView(arrangedSubviews: [avatarImageView, textStack])
        contentStack.axis = .horizontal
        contentStack.alignment = .top
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let mainStack = UIStackView(arrangedSubviews: [contentStack, imageContainerView, actionStack])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            avatarImageView.widthAnchor.constraint(equalToConstant: 55),
            avatarImageView.heightAnchor.constraint(equalToConstant: 55),
            imageHeightConstraint,
            tweetImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            tweetImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            tweetImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            tweetImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            imageContainerView.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: imageContainerView.leadingAnchor, constant: 12),
            errorLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageContainerView.trailingAnchor, constant: -12)
        ])
    }
    
    private func makeActionIcon(systemName: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: systemName))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }
    
    func configure(with post: Tweet) {
        errorLabel.text = nil
        errorLabel.isHidden = true
        tweetImageView.image = nil
        tweetImageView.alpha = 1
        imageHeightConstraint.constant = 0

        nameLabel.text = post.user
        handleLabel.text = post.userName
        tweetLabel.text = post.text
        
        if let image = post.image, image == "true" {
            let id = post.id
            guard let url = URL(string: "http://localhost:3000/tweet/image/" + id) else {
                errorLabel.isHidden = false
                imageContainerView.isHidden = false
                errorLabel.text = "⚠️ Invalid image URL"
                return
            }

            imageHeightConstraint.constant = 250
            imageContainerView.isHidden = false
            imageContainerView.backgroundColor = .secondarySystemBackground
            tweetImageView.isHidden = false
            tweetImageView.kf.setImage(with: url) { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.errorLabel.isHidden = true
                        self.tweetImageView.alpha = 1

                    case .failure(let error):
                        self.tweetImageView.alpha = 0.05
                        self.imageContainerView.backgroundColor = .secondarySystemBackground
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = "⚠️ \(error.localizedDescription)"
                    }
                }
            }
        }
        else {
            tweetImageView.image = nil
            imageHeightConstraint.constant = 0
            imageContainerView.isHidden = true
        }
    }
}
