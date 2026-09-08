//
//  ProfileInfoView.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 08/09/2026.
//

import UIKit

final class ProfileInfoView: UICollectionReusableView {

    static let reuseIdentifier = "ProfileInfoView"

    let profileImageContainer = UIView()
    var onEditPressed: (() -> Void)?

    private let profileImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(named: "logo")
        )

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 37.5

        return imageView
    }()

    private let editButton: UIButton = {

        let button = UIButton(type: .system)

        var config = UIButton.Configuration.plain()

        config.title = "Edit Profile"
        config.baseForegroundColor = .systemBlue
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 16,
            bottom: 10,
            trailing: 16
        )

        button.configuration = config

        button.layer.borderWidth = 1.5
        button.layer.borderColor =
            UIColor.systemBlue.cgColor

        button.layer.cornerRadius = 20

        return button
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.text = "Cem"
        label.font = .boldSystemFont(ofSize: 22)

        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()

        label.text = "@cem_salta"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)

        return label
    }()

    private let bioLabel: UILabel = {
        let label = UILabel()

        label.text =
            "Make education not fail! 4️⃣2️⃣ Founder @TurmaApp soon.. @ProbableApp"

        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0

        return label
    }()

    private let statsLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(user: UserModel) {
        profileImageView.image = UIImage(named: "logo")
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.userName)"
        bioLabel.text = user.bio ?? "No bio yet"
        statsLabel.attributedText = Self.makeStatsText(
            followers: user.followers.count,
            following: user.followings.count
        )
    }

    private func setupViews() {

        profileImageContainer.backgroundColor =
            .systemBackground

        profileImageContainer.layer.cornerRadius = 45

        addSubview(profileImageContainer)
        profileImageContainer.addSubview(profileImageView)

        addSubview(editButton)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(statsLabel)

        profileImageContainer.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        editButton.addTarget(self, action: #selector(openEditProfile), for: .touchUpInside)

        NSLayoutConstraint.activate([

            // Profile image

            profileImageContainer.topAnchor.constraint(
                equalTo: topAnchor,
                constant: -25
            ),

            profileImageContainer.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),

            profileImageContainer.widthAnchor.constraint(
                equalToConstant: 90
            ),

            profileImageContainer.heightAnchor.constraint(
                equalToConstant: 90
            ),

            profileImageView.centerXAnchor.constraint(
                equalTo: profileImageContainer.centerXAnchor
            ),

            profileImageView.centerYAnchor.constraint(
                equalTo: profileImageContainer.centerYAnchor
            ),

            profileImageView.widthAnchor.constraint(
                equalToConstant: 75
            ),

            profileImageView.heightAnchor.constraint(
                equalToConstant: 75
            ),

            // Edit Profile

            editButton.topAnchor.constraint(
                equalTo: topAnchor,
                constant: -5
            ),

            editButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),

            // Name

            nameLabel.topAnchor.constraint(
                equalTo: profileImageContainer.bottomAnchor,
                constant: 5
            ),

            nameLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),

            // Username

            usernameLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 3
            ),

            usernameLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),

            // Bio

            bioLabel.topAnchor.constraint(
                equalTo: usernameLabel.bottomAnchor,
                constant: 8
            ),

            bioLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),

            bioLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),

            // Stats

            statsLabel.topAnchor.constraint(
                equalTo: bioLabel.bottomAnchor,
                constant: 8
            ),

            statsLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),

            statsLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -15
            )
        ])
    }
    
    @objc func openEditProfile() {
        onEditPressed?()
    }

    private static func makeStatsText(
        followers: Int,
        following: Int
    ) -> NSAttributedString {
        let text = NSMutableAttributedString()

        text.append(
            NSAttributedString(
                string: "\(followers)",
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 15),
                    .foregroundColor: UIColor.label
                ]
            )
        )

        text.append(
            NSAttributedString(
                string: " Followers    ",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 15),
                    .foregroundColor: UIColor.secondaryLabel
                ]
            )
        )

        text.append(
            NSAttributedString(
                string: "\(following)",
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 15),
                    .foregroundColor: UIColor.label
                ]
            )
        )

        text.append(
            NSAttributedString(
                string: " Following",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 15),
                    .foregroundColor: UIColor.secondaryLabel
                ]
            )
        )

        return text
    }
}
