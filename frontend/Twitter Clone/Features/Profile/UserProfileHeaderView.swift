//
//  UserProfileHeaderView.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 08/09/2026.
//

import UIKit

final class UserProfileHeaderView: UICollectionReusableView {

    static let reuseIdentifier = "UserProfileHeaderView"

    let bannerImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(named: "banner")
        )

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(
            style: .systemMaterialDark
        )

        let view = UIVisualEffectView(effect: blur)
        view.alpha = 0

        return view
    }()

    let titleContainer = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.text = "Cem"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center

        return label
    }()

    private let tweetCountLabel: UILabel = {
        let label = UILabel()

        label.text = "150 Tweets"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = false

        addSubview(bannerImageView)
        addSubview(blurView)
        addSubview(titleContainer)

        titleContainer.addSubview(titleLabel)
        titleContainer.addSubview(tweetCountLabel)

        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tweetCountLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            bannerImageView.topAnchor.constraint(
                equalTo: topAnchor
            ),

            bannerImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            bannerImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            bannerImageView.heightAnchor.constraint(
                equalToConstant: 180
            ),

            blurView.topAnchor.constraint(
                equalTo: bannerImageView.topAnchor
            ),

            blurView.leadingAnchor.constraint(
                equalTo: bannerImageView.leadingAnchor
            ),

            blurView.trailingAnchor.constraint(
                equalTo: bannerImageView.trailingAnchor
            ),

            blurView.bottomAnchor.constraint(
                equalTo: bannerImageView.bottomAnchor
            ),

            titleContainer.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),

            titleContainer.bottomAnchor.constraint(
                equalTo: bannerImageView.bottomAnchor,
                constant: -20
            ),

            titleLabel.topAnchor.constraint(
                equalTo: titleContainer.topAnchor
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: titleContainer.leadingAnchor
            ),

            titleLabel.trailingAnchor.constraint(
                equalTo: titleContainer.trailingAnchor
            ),

            tweetCountLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 5
            ),

            tweetCountLabel.leadingAnchor.constraint(
                equalTo: titleContainer.leadingAnchor
            ),

            tweetCountLabel.trailingAnchor.constraint(
                equalTo: titleContainer.trailingAnchor
            ),

            tweetCountLabel.bottomAnchor.constraint(
                equalTo: titleContainer.bottomAnchor
            )
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(user: UserModel, tweetCount: Int) {
        titleLabel.text = user.name
        tweetCountLabel.text = "\(tweetCount) Tweets"
    }
}
