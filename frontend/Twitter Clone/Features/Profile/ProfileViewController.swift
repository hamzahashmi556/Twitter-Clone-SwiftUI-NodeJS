//
//  ProfileViewController.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 08/09/2026.
//

import UIKit
import Combine
import SwiftUI

final class ProfileViewController: UIViewController {
    
    private let vm: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let loadingOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.75)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let headerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()

    private let headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let headerView = UserProfileHeaderView()
    private let profileInfoView = ProfileInfoView()
    private let tabBarView = ProfileTabBarView()

    private let tabs = [
        "Tweets",
        "Tweets & Likes",
        "Media",
        "Likes"
    ]

    private var selectedTab = 0
    private var isHeaderConfigured = false
    
    private let container: AppContainer

    init(user: UserModel, container: AppContainer) {
        self.container = container
        self.vm = ProfileViewModel(user: user, tweetService: container.tweetService)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupTableView()
        setupHeader()
        setupLoadingOverlay()
        bindViewModel()
        refreshHeaderContent()
        updateHeaderSize()
        
        profileInfoView.onEditPressed = { [weak self] in
            guard let self else { return }
            let view = EditProfileViewController(
                user: vm.user,
                userUpdated: { updatedUser in
                    self.vm.user = updatedUser
                },
                userService: container.userService,
                presentingViewController: self
            )
            self.navigationController?.pushViewController(view, animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderSize()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            TweetTableViewCell.self,
            forCellReuseIdentifier: TweetTableViewCell.reuseIdentifier
        )

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        profileInfoView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.translatesAutoresizingMaskIntoConstraints = false

        tabBarView.delegate = self

        headerStackView.addArrangedSubview(headerView)
        headerStackView.addArrangedSubview(profileInfoView)
        headerStackView.addArrangedSubview(tabBarView)

        headerContainerView.addSubview(headerStackView)

        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor)
        ])

        tableView.tableHeaderView = headerContainerView
        isHeaderConfigured = true
    }

    private func setupLoadingOverlay() {
        view.addSubview(loadingOverlay)
        loadingOverlay.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        vm.$tweets
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.tableView.reloadData()
                self.refreshHeaderContent()
                self.updateHeaderSize()
            }
            .store(in: &cancellables)

        vm.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                self?.setLoading(isLoading)
            }
            .store(in: &cancellables)

        setLoading(vm.isLoading)
    }

    private func refreshHeaderContent() {
        guard isHeaderConfigured else { return }

        headerView.configure(user: vm.user, tweetCount: vm.tweets.count)
        profileInfoView.configure(user: vm.user)
        tabBarView.configure(selectedIndex: selectedTab)
    }

    private func updateHeaderSize() {
        guard tableView.bounds.width > 0 else { return }

        let targetSize = CGSize(
            width: tableView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )

        let size = headerContainerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        let updatedFrame = CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: size.height
        )

        if headerContainerView.frame != updatedFrame {
            headerContainerView.frame = updatedFrame
            tableView.tableHeaderView = headerContainerView
        }
    }

    private func setLoading(_ isLoading: Bool) {
        loadingOverlay.isHidden = !isLoading
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = !isLoading
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TweetTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? TweetTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: vm.tweets[indexPath.row])
        return cell
    }
}

extension ProfileViewController: TabBarViewDelegate {
    func tabBarView(_ tabBarView: ProfileTabBarView, didSelect index: Int) {
        selectedTab = index
        print("Selected tab:", tabs[index])
        tabBarView.configure(selectedIndex: index)
        tableView.reloadData()
    }
}
