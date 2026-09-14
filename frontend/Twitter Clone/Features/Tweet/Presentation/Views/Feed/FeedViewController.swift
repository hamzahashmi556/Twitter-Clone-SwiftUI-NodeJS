//
//  FeedViewController.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


import UIKit
import Combine

final class FeedViewController: UIViewController {
    
    private let viewModel: FeedViewModel
    private let container: AppContainer
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
    
    init(container: AppContainer) {
        self.container = container
        self.viewModel = FeedViewModel(
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
        bindViewModel()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: TweetCell.reuseIdentifier)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$tweets
            .combineLatest(viewModel.$otherUsers)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.reuseIdentifier, for: indexPath) as? TweetCell else {
            return UITableViewCell()
        }
        let tweet = viewModel.tweets[indexPath.row]
        let user = viewModel.otherUsers.first(where: { $0.id == tweet.userId })
        cell.configure(with: tweet, user: user)
        
        cell.likePressed = { [weak self] in
            guard let self = self else { return }
            Task {
                if tweet.likes.contains(UserDefaults.userID ?? "") {
                    await self.viewModel.unlike(tweetId: tweet.id)
                }
                else {
                    await self.viewModel.like(tweetId: tweet.id)
                }
                await MainActor.run {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        cell.profilePressed = { [weak self] in
            guard let self = self, let user else { return }
            let vc = ProfileViewController(user: user, container: container)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
