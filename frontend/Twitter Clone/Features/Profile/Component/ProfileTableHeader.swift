//
//  ProfileTableHeader.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 14/09/2026.
//

import UIKit

class ProfileTableHeader: UICollectionReusableView {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var imgBannerView: UIImageView!
    
    @IBOutlet weak var profileImgContainer: UIView!
    
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblFollowerFollowing: UILabel!
    
    var editPressed: (() -> Void)?
    
    @IBAction func editBtnPressed(_ sender: UIButton) {
        editPressed?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("ProfileTableHeader", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
        profileImgView.applyCircularWithBorder()
        
        // shadow image container
        profileImgContainer.backgroundColor = nil
        profileImgContainer.layer.shadowColor = UIColor.black.cgColor
        profileImgContainer.layer.shadowRadius = 10
        profileImgContainer.layer.shadowOpacity = 1
        profileImgContainer.layer.shadowOffset = .zero

    }
    
    func bindData(user: UserModel, tweetCount: Int) {
        if let base64 = user.avatar,
           let data = Data(base64Encoded: base64) {
            self.profileImgView.image = UIImage(data: data)
        }
        else {
            self.profileImgView.image = UIImage(systemName: "person")
        }
        
        self.lblName.text = user.name
        self.lblUsername.text = user.userName
        self.lblFollowerFollowing.text = "Followers \(user.followers.count) : Following \(user.followings.count)"
    }
}
