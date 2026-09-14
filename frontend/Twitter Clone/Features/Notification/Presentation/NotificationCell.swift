//
//  NotificationCell.swift
//  Twitter Clone
//
//  Created by Codex on 14/09/2026.
//

import UIKit

final class NotificationCell: UITableViewCell {
    static let reuseIdentifier = "NotificationCell"

    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 29 / 255, green: 161 / 255, blue: 242 / 255, alpha: 0.12)
        view.layer.cornerRadius = 22
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 29 / 255, green: 161 / 255, blue: 242 / 255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
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

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        bodyLabel.text = nil
        bodyLabel.isHidden = false
        iconImageView.image = nil
    }

    func configure(with notification: Notification) {
        titleLabel.text = "@\(notification.userName) \(notification.notificationType.message)"
        bodyLabel.text = notification.text
        bodyLabel.isHidden = notification.text?.isEmpty ?? true

        switch notification.notificationType {
        case .like:
            iconImageView.image = UIImage(systemName: "heart.fill")
            iconImageView.tintColor = .systemPink
            iconContainerView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.12)
        case .follow:
            iconImageView.image = UIImage(systemName: "person.fill.badge.plus")
            iconImageView.tintColor = UIColor(red: 29 / 255, green: 161 / 255, blue: 242 / 255, alpha: 1)
            iconContainerView.backgroundColor = UIColor(red: 29 / 255, green: 161 / 255, blue: 242 / 255, alpha: 0.12)
        }
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground

        iconContainerView.addSubview(iconImageView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(bodyLabel)
        containerStackView.addArrangedSubview(iconContainerView)
        containerStackView.addArrangedSubview(textStackView)
        contentView.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            iconContainerView.widthAnchor.constraint(equalToConstant: 44),
            iconContainerView.heightAnchor.constraint(equalToConstant: 44),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),

            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }
}
