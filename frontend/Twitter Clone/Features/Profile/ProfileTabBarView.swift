//
//  ProfileTabBarView.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 08/09/2026.
//

import UIKit

final class ProfileTabBarView: UICollectionReusableView {

    static let reuseIdentifier = "TabBarView"

    weak var delegate: TabBarViewDelegate?

    private let tabs = [
        "Tweets",
        "Tweets & Likes",
        "Media",
        "Likes"
    ]

    private var buttons: [UIButton] = []

    private let stackView: UIStackView = {

        let stack = UIStackView()

        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually

        return stack
    }()

    private let selectionIndicator: UIView = {

        let view = UIView()

        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 1.5

        return view
    }()

    private let divider: UIView = {

        let view = UIView()

        view.backgroundColor = .separator

        return view
    }()

    private var selectedIndex = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(selectedIndex: Int) {
        guard buttons.indices.contains(selectedIndex) else {
            return
        }

        self.selectedIndex = selectedIndex
        buttons.forEach { $0.isSelected = false }
        buttons[selectedIndex].isSelected = true
        layoutIfNeeded()

        let buttonFrame = buttons[selectedIndex].convert(
            buttons[selectedIndex].bounds,
            to: self
        )

        selectionIndicator.frame.origin.x = buttonFrame.midX - 35
    }

    private func setup() {

        backgroundColor = .systemBackground

        addSubview(stackView)
        addSubview(selectionIndicator)
        addSubview(divider)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            stackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 15
            ),

            stackView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            stackView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            stackView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),

            selectionIndicator.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),

            selectionIndicator.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            selectionIndicator.widthAnchor.constraint(
                equalToConstant: 70
            ),

            selectionIndicator.heightAnchor.constraint(
                equalToConstant: 3
            ),

            divider.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            divider.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            divider.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),

            divider.heightAnchor.constraint(
                equalToConstant: 0.5
            )
        ])

        for (index, title) in tabs.enumerated() {

            let button = UIButton(type: .system)

            button.setTitle(title, for: .normal)

            button.setTitleColor(
                .secondaryLabel,
                for: .normal
            )

            button.setTitleColor(
                .label,
                for: .selected
            )

            button.titleLabel?.font =
                .systemFont(ofSize: 15, weight: .semibold)

            button.tag = index

            button.addTarget(
                self,
                action: #selector(tabTapped(_:)),
                for: .touchUpInside
            )

            buttons.append(button)
            stackView.addArrangedSubview(button)
        }

        buttons.first?.isSelected = true
    }

    @objc private func tabTapped(_ sender: UIButton) {

        buttons.forEach {
            $0.isSelected = false
        }

        sender.isSelected = true
        selectedIndex = sender.tag

        let buttonFrame = sender.convert(
            sender.bounds,
            to: self
        )

        UIView.animate(
            withDuration: 0.25,
            animations: {

                self.selectionIndicator.frame.origin.x =
                    buttonFrame.midX - 35
            }
        )

        delegate?.tabBarView(
            self,
            didSelect: sender.tag
        )
    }
}

protocol TabBarViewDelegate: AnyObject {
    func tabBarView(
        _ tabBarView: ProfileTabBarView,
        didSelect index: Int
    )
}
