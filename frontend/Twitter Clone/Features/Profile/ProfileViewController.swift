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
        let tableView = UITableView(frame: .zero, style: .grouped)
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

    private let headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()
    
    private let headerView = ProfileTableHeader()
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
        self.vm = ProfileViewModel(
            user: user,
            tweetService: container.tweetService,
            userService: container.userService
        )
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
        
        
        headerView.editPressed = { [weak self] in
            guard let self else { return }
            if vm.user.isCurrentUser {
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
            else {
                // Follow / Unfollow
                Task {
                    let isFollowing = self.vm.user.followers.contains(UserDefaults.userID ?? "")
                    if isFollowing {
                        await self.vm.unfollow()
                    }
                    else {
                        await self.vm.follow()
                    }
                    await MainActor.run {
                        self.refreshHeaderContent()
                    }
                }
            }
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "TweetCell", bundle: nil),
            forCellReuseIdentifier: TweetCell.reuseIdentifier
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
        
        let tableWidth = tableView.frame.width

        tabBarView.delegate = self
        
        headerView.bounds = CGRect(
            origin: .zero,
            size: CGSize(width: tableWidth, height: 450)
        )
        tabBarView.bounds = CGRect(
            origin: .zero,
            size: CGSize(width: tableWidth, height: 45)
        )
        headerStackView.addArrangedSubview(headerView)
        headerStackView.addArrangedSubview(tabBarView)
        
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
        
        if vm.user.isCurrentUser {
            headerView.bindData(user: vm.user, tweetCount: vm.tweets.count)
        }
        else {
            let isFollowing = vm.user.followers.contains(UserDefaults.userID ?? "")
            headerView.bindOtherUserData(otherUser: vm.user, isFollowing: isFollowing)
        }
        tabBarView.configure(selectedIndex: selectedTab)
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
            withIdentifier: TweetCell.reuseIdentifier,
            for: indexPath
        ) as? TweetCell else {
            return UITableViewCell()
        }
        
        let tweet = vm.tweets[indexPath.row]
        cell.configure(with: tweet, user: vm.user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 355
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerStackView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 355
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
