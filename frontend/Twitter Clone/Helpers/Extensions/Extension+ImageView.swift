//
//  Extension+ImageView.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 14/09/2026.
//

import UIKit

extension UIImageView {
    
    func applyCircularWithBorder() {
        // border color
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
        
        // circle shape
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill

    }
}
