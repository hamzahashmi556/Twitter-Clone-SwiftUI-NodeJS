//
//  EditProfileViewController+UI.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 08/09/2026.
//

import UIKit

extension EditProfileViewController {

    // MARK: - UI Setup

    func setupUI() {

        view.backgroundColor = .systemBackground
        
        self.title = "Edit Profile"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(self.saveTapped))
        
        // Website configuration
        websiteField.textField.keyboardType = .URL
        websiteField.textField.autocapitalizationType = .none

        // View hierarchy
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubview(profileHeader)

        contentView.addSubview(nameField)
        contentView.addSubview(locationField)
        contentView.addSubview(bioField)
        contentView.addSubview(websiteField)

        setupLayout()
    }

    // MARK: - Layout

    private func setupLayout() {

        [
            scrollView,
            contentView,
            profileHeader,
            nameField,
            locationField,
            bioField,
            websiteField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([

            // MARK: Scroll View

            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            // MARK: Content View

            contentView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),
            contentView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor
            ),
            contentView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),
            contentView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor
            ),

            // MARK: Banner
            profileHeader.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            profileHeader.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            profileHeader.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            profileHeader.heightAnchor.constraint(
                equalToConstant: 210
            ),

            // MARK: Name

            nameField.topAnchor.constraint(
                equalTo: profileHeader.bottomAnchor,
                constant: 16
            ),
            nameField.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            nameField.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            // MARK: Location

            locationField.topAnchor.constraint(
                equalTo: nameField.bottomAnchor
            ),
            locationField.leadingAnchor.constraint(
                equalTo: nameField.leadingAnchor
            ),
            locationField.trailingAnchor.constraint(
                equalTo: nameField.trailingAnchor
            ),

            // MARK: Bio

            bioField.topAnchor.constraint(
                equalTo: locationField.bottomAnchor
            ),
            bioField.leadingAnchor.constraint(
                equalTo: nameField.leadingAnchor
            ),
            bioField.trailingAnchor.constraint(
                equalTo: nameField.trailingAnchor
            ),

            // MARK: Website

            websiteField.topAnchor.constraint(
                equalTo: bioField.bottomAnchor
            ),
            websiteField.leadingAnchor.constraint(
                equalTo: nameField.leadingAnchor
            ),
            websiteField.trailingAnchor.constraint(
                equalTo: nameField.trailingAnchor
            ),
            websiteField.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -20
            )
        ])
    }
}
