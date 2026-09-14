//
//  EditProfileHeader.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 14/09/2026.
//

import UIKit
import Kingfisher

class EditProfileHeader: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgBannerView: UIImageView!
    @IBOutlet weak var profileImgContainer: UIView!
    @IBOutlet weak var profileImgVIew: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupTapGesture()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("EditProfileHeader", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
        // border color
        profileImgVIew.layer.borderColor = UIColor.white.cgColor
        profileImgVIew.layer.borderWidth = 3
        
        // circle shape
        profileImgVIew.layer.cornerRadius = self.profileImgVIew.bounds.width / 2
        profileImgVIew.clipsToBounds = true
        profileImgVIew.contentMode = .scaleAspectFill
        
        // shadow image container
        profileImgContainer.backgroundColor = nil
        profileImgContainer.layer.shadowColor = UIColor.black.cgColor
        profileImgContainer.layer.shadowRadius = 10
        profileImgContainer.layer.shadowOpacity = 1
        profileImgContainer.layer.shadowOffset = .zero

    }
    
    func bindData(user: UserModel) {
        if let base64 = user.avatar, let data = Data(base64Encoded: base64) {
            self.profileImgVIew.image = UIImage(data: data)
        }
    }
    
    func updateProfile(image: UIImage) {
        self.profileImgVIew.image = image
    }
    
    private func setupTapGesture() {
        let tg = UITapGestureRecognizer()
        tg.numberOfTapsRequired = 1
        profileImgVIew.addGestureRecognizer(tg)
        profileImgVIew.isUserInteractionEnabled = true
    }
}
