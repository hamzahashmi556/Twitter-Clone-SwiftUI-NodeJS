//
//  TweetTableViewCell.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import UIKit

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
        imageView.layer.cornerRadius = 14
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        self.imageHeightConstraint = tweetImageView.heightAnchor.constraint(equalToConstant: 0)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let headerStack = UIStackView(arrangedSubviews: [nameLabel, handleLabel])
        headerStack.axis = .vertical
        headerStack.alignment = .leading
        headerStack.spacing = 2
        
        let textStack = UIStackView(arrangedSubviews: [headerStack, tweetLabel, tweetImageView, actionStack])
        textStack.axis = .vertical
        textStack.alignment = .fill
        textStack.spacing = 12
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        let commentImage = makeActionIcon(systemName: "message")
        let retweetImage = makeActionIcon(systemName: "arrow.2.squarepath")
        let likeImage = makeActionIcon(systemName: "heart")
        let shareImage = makeActionIcon(systemName: "square.and.arrow.up")
        
        [commentImage, retweetImage, likeImage, shareImage].forEach { actionStack.addArrangedSubview($0) }
        
        let contentStack = UIStackView(arrangedSubviews: [avatarImageView, textStack])
        contentStack.axis = .horizontal
        contentStack.alignment = .top
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            avatarImageView.widthAnchor.constraint(equalToConstant: 55),
            avatarImageView.heightAnchor.constraint(equalToConstant: 55),
            tweetImageView.widthAnchor.constraint(equalTo: textStack.widthAnchor),
            imageHeightConstraint
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
        nameLabel.text = post.user
        handleLabel.text = post.userName
        tweetLabel.text = post.text
        
        
        if let image = post.image,
           let data = Data(base64Encoded: image.buffer),
           let image = UIImage(data: data) {
            tweetImageView.image = image
            imageHeightConstraint.constant = 250
            tweetImageView.isHidden = false
        }
        else {
            tweetImageView.image = nil
            imageHeightConstraint.constant = 0
            tweetImageView.isHidden = true
        }
    }
}
