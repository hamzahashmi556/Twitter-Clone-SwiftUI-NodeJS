//
//  CreateTweetViewModel.swift
//  twitter-clone (iOS)
//
//  Created by cem on 8/10/21.
//

import Foundation

class CreateTweetViewModel: ObservableObject {
    
    func uploadPost(text: String) {
        
        RequestServices.requestDomain = "http://localhost:3000/tweets"
        
        RequestServices.postTweet(text: text, user: "Cem") { (res) in
            print("Tweet saved")
        }
    }   
}
