//
//  SlideMenuViewController.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


import UIKit

final class SlideMenuViewController: UIViewController {
    private let user: UserModel?
    private let menuItems = ["Profile", "Lists", "Topics", "Bookmarks", "Moments"]
    
    init(user: UserModel?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        let avatar = UIImageView(image: UIImage(named: "logo"))
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 30
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.widthAnchor.constraint(equalToConstant: 60).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.text = user?.name ?? "Cem"
        
        let handleLabel = UILabel()
        handleLabel.font = .systemFont(ofSize: 15)
        handleLabel.textColor = .secondaryLabel
        handleLabel.text = "@\(user?.userName ?? "cem_salta")"
        
        let countStack = UIStackView(arrangedSubviews: [makeCountView(count: 8, title: "Following"), makeCountView(count: 18, title: "Followers")])
        countStack.axis = .horizontal
        countStack.spacing = 18
        
        let profileStack = UIStackView(arrangedSubviews: [avatar, nameLabel, handleLabel, countStack])
        profileStack.axis = .vertical
        profileStack.alignment = .leading
        profileStack.spacing = 10
        
        let menuStack = UIStackView()
        menuStack.axis = .vertical
        menuStack.spacing = 10
        
        menuItems.forEach { title in
            menuStack.addArrangedSubview(makeMenuButton(title: title))
        }
        
        let footerStack = UIStackView(arrangedSubviews: [makePlainButton(title: "Settings and privacy"), makePlainButton(title: "Help centre")])
        footerStack.axis = .vertical
        footerStack.spacing = 18
        
        let mainStack = UIStackView(arrangedSubviews: [profileStack, divider(), menuStack, divider(), footerStack])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollView = UIScrollView()
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
            mainStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func makeCountView(count: Int, title: String) -> UIView {
        let countLabel = UILabel()
        countLabel.font = .systemFont(ofSize: 17, weight: .bold)
        countLabel.text = "\(count)"
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textColor = .secondaryLabel
        titleLabel.text = title
        
        let stack = UIStackView(arrangedSubviews: [countLabel, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 4
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
