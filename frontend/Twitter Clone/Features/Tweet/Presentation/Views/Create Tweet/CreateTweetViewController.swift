//
//  CreateTweetViewController.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


import UIKit
import Combine

final class CreateTweetViewController: UIViewController {
    
    private let viewModel: CreateTweetViewModel
    private var cancellables = Set<AnyCancellable>()
    private var selectedImage: UIImage?
    
    private let cancelButton = UIButton(type: .system)
    private let tweetButton = UIButton(type: .system)
    private let textView = UITextView()
    private let placeholderLabel = UILabel()
    private let imagePreviewView = UIImageView()
    private let addImageButton = UIButton(type: .system)
    private let loadingOverlay = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var photoPickerPresenter: PhotoPickerPresenter?
    
    init(tweetService: TweetServiceProtocol, user: UserModel) {
        self.viewModel = CreateTweetViewModel(service: tweetService, user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
        bindViewModel()
    }
    
    private func setupUI() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        
        tweetButton.setTitle("Tweet", for: .normal)
        tweetButton.setTitleColor(.white, for: .normal)
        tweetButton.backgroundColor = UIColor(red: 29 / 255, green: 161 / 255, blue: 242 / 255, alpha: 1)
        tweetButton.layer.cornerRadius = 18
        tweetButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
        
        let headerStack = UIStackView(arrangedSubviews: [cancelButton, UIView(), tweetButton])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        textView.font = .systemFont(ofSize: 20)
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderLabel.text = "What's happening?"
        placeholderLabel.textColor = .secondaryLabel
        placeholderLabel.font = .systemFont(ofSize: 20)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imagePreviewView.contentMode = .scaleAspectFill
        imagePreviewView.clipsToBounds = true
        imagePreviewView.layer.cornerRadius = 14
        imagePreviewView.translatesAutoresizingMaskIntoConstraints = false
        imagePreviewView.isHidden = true
        
        addImageButton.setTitle("Add Photo", for: .normal)
        addImageButton.setTitleColor(UIColor(red: 29 / 255, green: 161 / 255, blue: 242 / 255, alpha: 1), for: .normal)
        addImageButton.contentHorizontalAlignment = .leading
        
        let contentStack = UIStackView(arrangedSubviews: [textView, imagePreviewView, addImageButton])
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        loadingOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        loadingOverlay.translatesAutoresizingMaskIntoConstraints = false
        loadingOverlay.isHidden = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(headerStack)
        view.addSubview(contentStack)
        view.addSubview(placeholderLabel)
        view.addSubview(loadingOverlay)
        loadingOverlay.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            contentStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 180),
            imagePreviewView.heightAnchor.constraint(equalToConstant: 220),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 4),
            
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        tweetButton.addTarget(self, action: #selector(didTapTweet), for: .touchUpInside)
        addImageButton.addTarget(self, action: #selector(didTapAddImage), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                self?.setLoading(isLoading)
            }
            .store(in: &cancellables)
        
        AlertManager.shared.$errorMsg
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard !message.isEmpty else { return }
                self?.presentAlert(title: "Error", message: message)
                AlertManager.shared.errorMsg = ""
            }
            .store(in: &cancellables)
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapTweet() {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, text != "What's happening?" else {
            presentAlert(title: "Missing Tweet", message: "Please enter some text before posting.")
            return
        }
        
        viewModel.text = text
        viewModel.image = selectedImage?.jpegData(compressionQuality: 0.5)
        
        viewModel.post { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func didTapAddImage() {
        photoPickerPresenter = PhotoPickerPresenter(presentingViewController: self, onImagePicked: { [weak self] image in
            self?.selectedImage = image
            self?.imagePreviewView.image = image
            self?.imagePreviewView.isHidden = false
        }, onCancel: {
            print("Photo picker dismissed without selection")
        })
        photoPickerPresenter?.present()
    }
    
    private func setLoading(_ isLoading: Bool) {
        loadingOverlay.isHidden = !isLoading
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = !isLoading
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension CreateTweetViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

