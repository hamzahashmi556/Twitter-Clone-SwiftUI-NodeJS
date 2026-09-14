//
//  EditProfileView.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 08/09/2026.
//

import UIKit
import Combine
import Kingfisher

final class EditProfileViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let viewModel: EditProfileViewModel
    private let userUpdated: (UserModel) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    private var photoPickerPresenter: PhotoPickerPresenter?
    
    // MARK: - State
    
    private var selectedImage: UIImage? {
        didSet {
            guard let selectedImage else { return }
            profileHeader.updateProfile(image: selectedImage)
        }
    }
    
    // MARK: - Initialization
    
    init(
        user: UserModel,
        userUpdated: @escaping (UserModel) -> Void,
        userService: UserServiceProtocol,
        presentingViewController: UIViewController
    ) {
        self.userUpdated = userUpdated
        self.viewModel = EditProfileViewModel(
            user: user,
            service: userService
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        populateData()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        
        cancelButton.addTarget(
            self,
            action: #selector(cancelTapped),
            for: .touchUpInside
        )
        
        saveButton.addTarget(
            self,
            action: #selector(saveTapped),
            for: .touchUpInside
        )
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc func saveTapped() {
        
        view.endEditing(true)
        
        updateViewModel()
        
        saveButton.isEnabled = false
        
        viewModel.save(selectedImage: selectedImage) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.saveButton.isEnabled = true
                self.userUpdated(self.viewModel.user)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func profileImageTapped() {
        
        self.photoPickerPresenter = PhotoPickerPresenter(
            presentingViewController: self,
            onImagePicked: { [weak self] image in
                self?.selectedImage = image
            },
            onCancel: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
        
        self.photoPickerPresenter?.present()
    }
    
    private func populateData() {
        
        nameField.textField.text = viewModel.name
        locationField.textField.text = viewModel.location
        bioField.textView.text = viewModel.bio
        websiteField.textField.text = viewModel.website
        profileHeader.bindData(user: viewModel.user)
    }
    
    private func updateViewModel() {
        
        viewModel.name = nameField.textField.text ?? ""
        viewModel.location = locationField.textField.text ?? ""
        viewModel.bio = bioField.textView.text ?? ""
        viewModel.website = websiteField.textField.text ?? ""
    }
    
    // MARK: - UI Properties
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let profileHeader: EditProfileHeader = {
        let header = EditProfileHeader()
        return header
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        return button
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit profile"
        label.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )
        return label
    }()

    let nameField = EditProfileFieldView(
        title: "Name",
        placeholder: "Add your name"
    )

    let locationField = EditProfileFieldView(
        title: "Location",
        placeholder: "Add your location"
    )

    let bioField = EditProfileFieldView(
        title: "Bio",
        type: EditProfileFieldView.FieldType.textView
    )

    let websiteField = EditProfileFieldView(
        title: "Website",
        placeholder: "Add your website"
    )
}
