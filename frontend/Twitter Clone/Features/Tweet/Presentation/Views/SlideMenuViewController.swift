//
//  SlideMenuViewController.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import UIKit
import Combine

final class SlideMenuViewController: UIViewController {
    var onProfileTapped: (() -> Void)?
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let handleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        return label
    }()

    private let followingValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let followersValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let followingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.text = "Following"
        return label
    }()

    private let followersTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.text = "Followers"
        return label
    }()

    private let scrollView = UIScrollView()
    private let mainStack = UIStackView()
    private let menuItems = ["Profile", "Lists", "Topics", "Bookmarks", "Moments"]
    private var user: UserModel?
    private var cancellables = Set<AnyCancellable>()

    init(authVM: AuthViewModel, onProfileTapped: (() -> Void)? = nil) {
        self.onProfileTapped = onProfileTapped
        super.init(nibName: nil, bundle: nil)
        authVM.$currentUser
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                guard let self else { return }
                self.user = user
                self.updateUI(with: user)
            }
            .store(in: &cancellables)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        updateUI(with: user)
        let tg = UITapGestureRecognizer(target: self, action: #selector(pushProfile))
        tg.numberOfTapsRequired = 1
        self.avatarImageView.addGestureRecognizer(tg)
    }
    
    @objc func pushProfile() {
        onProfileTapped?()
    }

    private func setupUI() {
        let profileStack = UIStackView(arrangedSubviews: [
            avatarImageView,
            nameLabel,
            handleLabel,
            makeCountStack()
        ])
        profileStack.axis = .vertical
        profileStack.alignment = .leading
        profileStack.spacing = 10

        let menuStack = UIStackView()
        menuStack.axis = .vertical
        menuStack.spacing = 10
        menuItems.forEach { title in
            menuStack.addArrangedSubview(makeMenuButton(title: title))
        }

        let footerStack = UIStackView(arrangedSubviews: [
            makePlainButton(title: "Settings and privacy"),
            makePlainButton(title: "Help centre")
        ])
        footerStack.axis = .vertical
        footerStack.spacing = 18

        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(profileStack)
        mainStack.addArrangedSubview(divider())
        mainStack.addArrangedSubview(menuStack)
        mainStack.addArrangedSubview(divider())
        mainStack.addArrangedSubview(footerStack)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            mainStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            mainStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),

            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func updateUI(with user: UserModel?) {
        nameLabel.text = user?.name ?? "Cem"
        handleLabel.text = "@\(user?.userName ?? "cem_salta")"
        followingValueLabel.text = "\(user?.followings.count ?? 0)"
        followersValueLabel.text = "\(user?.followers.count ?? 0)"
    }

    private func makeCountStack() -> UIStackView {
        let followingStack = UIStackView(arrangedSubviews: [followingValueLabel, followingTitleLabel])
        followingStack.axis = .vertical
        followingStack.alignment = .leading
        followingStack.spacing = 4

        let followersStack = UIStackView(arrangedSubviews: [followersValueLabel, followersTitleLabel])
        followersStack.axis = .vertical
        followersStack.alignment = .leading
        followersStack.spacing = 4

        let stack = UIStackView(arrangedSubviews: [followingStack, followersStack])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 18
        return stack
    }

    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        return button
    }

    private func makePlainButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }

    private func divider() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
}
