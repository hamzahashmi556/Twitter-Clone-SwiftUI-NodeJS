//
//  RegisterView.swift
//  twitter-clone (iOS)
//
//  Created by cem on 8/10/21.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var name = ""
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    
    @ObservedObject var vm: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
            Text("Create your account")
                .font(.title)
                .bold()
                .padding(.top, 35)
            
            VStack(alignment: .leading) {
                CustomAuthTextField(placeHolder: "Username", text: $userName)
                CustomAuthTextField(placeHolder: "Name", text: $name)
                CustomAuthTextField(placeHolder: "Phone number or email address", text: $email)
                CustomAuthTextField(placeHolder: "Password", text: $password)
            }
            
            Spacer(minLength: 0)
            
            VStack {
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                HStack {
                    
                    
                    Spacer()
                    
                    Button(action: {
                        vm.register(name: name, userName: userName, email: email, password: password)
                    }, label: {
                        Capsule()
                            .frame(width: 60, height: 30, alignment: .center)
                            .foregroundColor(Color(red: 29 / 255, green: 161 / 255, blue: 242 / 255))
                            .overlay(
                                Text("Next")
                                    .foregroundColor(.white)
                            )
                        
                    })
                    .padding(.trailing, 24)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("Twitter")
                    .resizable()
                    .scaledToFill()
                    .padding(.trailing)
                    .frame(width: 20, height: 20)
            }
        }
    }
}
