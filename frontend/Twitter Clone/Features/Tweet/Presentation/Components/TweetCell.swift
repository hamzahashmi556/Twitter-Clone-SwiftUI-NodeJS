//
//  TweetCell.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 14/09/2026.
//

import UIKit
import Kingfisher

class TweetCell: UITableViewCell {
    
    static let reuseIdentifier = "TweetCell"
    
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblTweet: UILabel!
    
    @IBOutlet weak var tweetImgView: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var profilePressed: (() -> Void)?
    
    var commentPressed: (() -> Void)?
    
    var retweetPressed: (() -> Void)?
    
    var likePressed: (() -> Void)?
    
    var sharePressed: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImgView.applyCircularWithBorder()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        tapGesture.numberOfTapsRequired = 1
        profileImgView.addGestureRecognizer(tapGesture)
        profileImgView.isUserInteractionEnabled = true
        
        tweetImgView.backgroundColor = .secondarySystemBackground
        tweetImgView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func profileTapped() {
        profilePressed?()
    }
    
    func configure(with post: Tweet, user: UserModel?) {
        errorLabel.text = nil
        errorLabel.isHidden = true
        tweetImgView.image = nil
        tweetImgView.alpha = 1

        lblName.text = user?.name ?? post.user
        lblUserName.text = "@" + (user?.userName ?? post.userName)
        lblTweet.text = post.text
        
        DispatchQueue.global().async {
            if let base64 = user?.avatar,
               let data = Data(base64Encoded: base64) {
                DispatchQueue.main.async {
                    self.profileImgView.image = UIImage(data: data)
                }
            }
        }
        
        if let image = post.image, image == "true" {
            let id = post.id
            guard let url = URL(string: "http://localhost:3000/tweet/image/" + id) else {
                errorLabel.isHidden = false
                errorLabel.text = "⚠️ Invalid image URL"
                return
            }
            
            tweetImgView.isHidden = false
            tweetImgView.kf.setImage(with: url) { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.errorLabel.isHidden = true

                    case .failure(let error):
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = "⚠️ \(error.localizedDescription)"
                    }
                }
            }
        }
        else {
            tweetImgView.isHidden = true
            tweetImgView.image = nil
        }
    }

    
    @IBAction func actionComment(_ sender: UIButton) {
        commentPressed?()
    }
    
    @IBAction func actionRetweet(_ sender: UIButton) {
        retweetPressed?()
    }
    
    @IBAction func actionLike(_ sender: UIButton) {
        likePressed?()
    }
    
    @IBAction func actionShare(_ sender: UIButton) {
        sharePressed?()
    }
}
