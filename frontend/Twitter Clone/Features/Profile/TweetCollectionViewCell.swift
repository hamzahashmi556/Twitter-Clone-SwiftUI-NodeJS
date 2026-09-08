//
//  TweetCollectionViewCell.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 08/09/2026.
//

import UIKit

final class TweetCollectionViewCell:
    UICollectionViewCell {

    static let reuseIdentifier =
        "TweetCollectionViewCell"

    private let avatarImageView: UIImageView = {

        let imageView = UIImageView(
            image: UIImage(named: "logo")
        )

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22

        return imageView
    }()

    private let nameLabel: UILabel = {

        let label = UILabel()

        label.text = "Cem"
        label.font =
            .systemFont(ofSize: 15, weight: .bold)

        return label
    }()

    private let usernameLabel: UILabel = {

        let label = UILabel()

        label.text = "@cem_salta"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    private let tweetLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0

        return label
    }()

    private let postImageView: UIImageView = {

        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12

        return imageView
    }()

    private let separatorView: UIView = {

        let view = UIView()

        view.backgroundColor = .separator

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(tweetLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(separatorView)

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        tweetLabel.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            avatarImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 14
            ),

            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            avatarImageView.widthAnchor.constraint(
                equalToConstant: 44
            ),

            avatarImageView.heightAnchor.constraint(
                equalToConstant: 44
            ),

            nameLabel.topAnchor.constraint(
                equalTo: avatarImageView.topAnchor
            ),

            nameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: 10
            ),

            usernameLabel.leadingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor,
                constant: 6
            ),

            usernameLabel.centerYAnchor.constraint(
                equalTo: nameLabel.centerYAnchor
            ),

            tweetLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 6
            ),

            tweetLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),

            tweetLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            postImageView.topAnchor.constraint(
                equalTo: tweetLabel.bottomAnchor,
                constant: 10
            ),

            postImageView.leadingAnchor.constraint(
                equalTo: tweetLabel.leadingAnchor
            ),

            postImageView.trailingAnchor.constraint(
                equalTo: tweetLabel.trailingAnchor
            ),

            postImageView.heightAnchor.constraint(
                equalToConstant: 180
            ),

            separatorView.topAnchor.constraint(
                equalTo: postImageView.bottomAnchor,
                constant: 14
            ),

            separatorView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            separatorView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            separatorView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),

            separatorView.heightAnchor.constraint(
                equalToConstant: 0.5
            )
        ])
    }

    func configure(
        tweet: String,
        imageName: String?
    ) {

        tweetLabel.text = tweet

        if let imageName {

            postImageView.image =
                UIImage(named: imageName)

            postImageView.isHidden = false

        } else {

            postImageView.image = nil
            postImageView.isHidden = true
        }
    }
}
