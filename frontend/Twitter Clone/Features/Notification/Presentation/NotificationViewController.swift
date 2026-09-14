//
//  NotificationViewController.swift
//  Twitter Clone
//
//  Created by Codex on 14/09/2026.
//

import Combine
import UIKit

final class NotificationViewController: UIViewController {
    private let authVM: AuthViewModel
    private let viewModel: NotificationViewModel
    private var cancellables = Set<AnyCancellable>()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 82
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No notifications yet."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    init(notificationVM: NotificationViewModel, authVM: AuthViewModel) {
        self.authVM = authVM
        self.viewModel = notificationVM
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupUI()
        bindViewModel()
        viewModel.fetchNotifications(userID: authVM.currentUser?.id)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchNotifications(userID: authVM.currentUser?.id)
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseIdentifier)
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -32),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18)
        ])
    }

    private func bindViewModel() {
        viewModel.$notifications
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                self?.setLoading(isLoading)
            }
            .store(in: &cancellables)

        authVM.$currentUser
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.viewModel.fetchNotifications(userID: user?.id)
            }
            .store(in: &cancellables)
    }

    private func setLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    private func updateEmptyState() {
        let hasNotifications = !viewModel.notifications.isEmpty
        tableView.isHidden = !hasNotifications
        emptyStateLabel.isHidden = hasNotifications
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.reuseIdentifier,
            for: indexPath
        ) as? NotificationCell else {
            return UITableViewCell()
        }

        cell.configure(with: viewModel.notifications[indexPath.row])
        return cell
    }
}
