//
//  BaseViewController.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 14/09/2026.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Publishers.CombineLatest3(
            AlertManager.shared.$isPresented,
            AlertManager.shared.$title,
            AlertManager.shared.$errorMsg
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] (isPresented, title, message) in
            guard let self, isPresented else { return }
            self.presentAlert(title: title, message: message)
        }
        .store(in: &cancellables)
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            AlertManager.shared.dismiss()
        }))
        present(alert, animated: true)
    }
}
