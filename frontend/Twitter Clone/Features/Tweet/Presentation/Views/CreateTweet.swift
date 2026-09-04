//
//  CreateTweet.swift
//  twitter-clone (iOS)
//
//  Created by cem on 8/1/21.
//

import SwiftUI

struct CreateTweet : View {
    
    @StateObject private var vm: CreateTweetViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    init(tweetService: TweetServiceProtocol, user: UserModel) {
        self._vm = StateObject(wrappedValue: CreateTweetViewModel(service: tweetService, user: user))
    }

    var body : some View {

        VStack{
            
            HStack{
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                }
                
                Spacer()
                
                Button(action: {
                    vm.post { tweet in
                        dismiss()
                    }
                }) {
                    Text("Tweet").padding()
                }.background(Color("bg"))
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            
            MultilineTextField(text: $vm.text)
            
        }
        .padding()
        .overlay {
            if vm.isLoading {
                ProgressView()
            }
        }
    }
}
