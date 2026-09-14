//
//  SearchUserCell.swift
//  Twitter Clone
//
//  Created by Codex on 14/09/2026.
//

import UIKit

final class SearchUserCell: UITableViewCell {
    static let reuseIdentifier = "SearchUserCell"

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()

    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    private let countsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 3
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = UIImage(named: "logo")
        nameLabel.text = nil
        userNameLabel.text = nil
        bioLabel.text = nil
        countsLabel.text = nil
    }

    func configure(with user: UserModel) {
        nameLabel.text = user.name
        userNameLabel.text = "@\(user.userName)"
        bioLabel.text = user.bio
        bioLabel.isHidden = user.bio?.isEmpty ?? true
        countsLabel.text = "\(user.followings.count) Following   \(user.followers.count) Followers"

        if let avatar = user.avatar,
           let data = Data(base64Encoded: avatar),
           let image = UIImage(data: data) {
            avatarImageView.image = image
        }
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground

        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(userNameLabel)
        textStackView.addArrangedSubview(bioLabel)
        textStackView.addArrangedSubview(countsLabel)

        containerStackView.addArrangedSubview(avatarImageView)
        containerStackView.addArrangedSubview(textStackView)

        contentView.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 52),
            avatarImageView.heightAnchor.constraint(equalToConstant: 52),

            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
