//
//  EditProfileFieldView.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 08/09/2026.
//


import UIKit

final class EditProfileFieldView: UIView {

    // MARK: - Types

    enum FieldType {
        case textField
        case textView
    }

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .label
        textField.borderStyle = .none
        return textField
    }()

    let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        return textView
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    // MARK: - Properties

    private let fieldType: FieldType

    // MARK: - Initialization

    init(
        title: String,
        placeholder: String = "",
        type: FieldType = .textField
    ) {
        self.fieldType = type

        super.init(frame: .zero)

        titleLabel.text = title
        textField.placeholder = placeholder

        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {

        addSubview(titleLabel)
        addSubview(dividerView)

        switch fieldType {
        case .textField:
            addSubview(textField)

        case .textView:
            addSubview(textView)
        }
    }

    // MARK: - Layout

    private func setupLayout() {

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            titleLabel.widthAnchor.constraint(
                equalToConstant: 70
            ),

            dividerView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            dividerView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            dividerView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),

            dividerView.heightAnchor.constraint(
                equalToConstant: 0.5
            )
        ])

        switch fieldType {

        case .textField:

            textField.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([

                textField.topAnchor.constraint(
                    equalTo: topAnchor,
                    constant: 10
                ),

                textField.leadingAnchor.constraint(
                    equalTo: titleLabel.trailingAnchor,
                    constant: 12
                ),

                textField.trailingAnchor.constraint(
                    equalTo: trailingAnchor
                ),

                textField.heightAnchor.constraint(
                    equalToConstant: 40
                )
            ])

            heightAnchor.constraint(
                equalToConstant: 57
            ).isActive = true

        case .textView:

            textView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([

                textView.topAnchor.constraint(
                    equalTo: topAnchor,
                    constant: 12
                ),

                textView.leadingAnchor.constraint(
                    equalTo: titleLabel.trailingAnchor,
                    constant: 12
                ),

                textView.trailingAnchor.constraint(
                    equalTo: trailingAnchor
                ),

                textView.bottomAnchor.constraint(
                    equalTo: dividerView.topAnchor,
                    constant: -12
                )
            ])

            heightAnchor.constraint(
                equalToConstant: 120
            ).isActive = true
        }
    }
}
