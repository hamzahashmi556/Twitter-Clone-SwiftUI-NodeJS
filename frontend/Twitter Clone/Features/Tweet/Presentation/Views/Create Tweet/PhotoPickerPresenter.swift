//
//  PhotoPickerPresenter.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import UIKit
import PhotosUI

final class PhotoPickerPresenter: NSObject {
    
    typealias ImageSelectionHandler = (UIImage) -> Void
    typealias CancellationHandler = () -> Void
    
    private weak var presentingViewController: UIViewController?
    private let selectionLimit: Int
    private let filter: PHPickerFilter
    private let onImagePicked: ImageSelectionHandler
    private let onCancel: CancellationHandler?
    
    init(
        presentingViewController: UIViewController,
        selectionLimit: Int = 1,
        filter: PHPickerFilter = .images,
        onImagePicked: @escaping ImageSelectionHandler,
        onCancel: CancellationHandler? = nil
    ) {
        self.presentingViewController = presentingViewController
        self.selectionLimit = selectionLimit
        self.filter = filter
        self.onImagePicked = onImagePicked
        self.onCancel = onCancel
    }
    
    func present(animated: Bool = true) {
        guard let presentingViewController else { return }
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = selectionLimit
        configuration.filter = filter
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        presentingViewController.present(picker, animated: animated)
    }
}

extension PhotoPickerPresenter: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else {
            onCancel?()
            return
        }
        
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
            onCancel?()
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let self, let image = object as? UIImage else {
                DispatchQueue.main.async {
                    self?.onCancel?()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.onImagePicked(image)
            }
        }
    }
}
