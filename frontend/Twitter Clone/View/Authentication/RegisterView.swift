//
//  RegisterView.swift
//  twitter-clone (iOS)
//
//  Created by cem on 8/10/21.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var vm: RegisterViewModel
    
    init(authService: AuthServiceProtocol) {
        self._vm = StateObject(wrappedValue: RegisterViewModel(service: authService))
    }
    
    var body: some View {
        VStack {
            ZStack {
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    })
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Image("Twitter")
                    .resizable()
                    .scaledToFill()
                    .padding(.trailing)
                    .frame(width: 20, height: 20)
            }
            
            Text("Create your account")
                .font(.title)
                .bold()
                .padding(.top, 35)
            
            VStack(alignment: .leading) {
                CustomAuthTextField(placeHolder: "Username", text: $vm.userName)
                CustomAuthTextField(placeHolder: "Name", text: $vm.name)
                CustomAuthTextField(placeHolder: "Phone number or email address", text: $vm.email)
                CustomAuthTextField(placeHolder: "Password", text: $vm.password)
            }
            
            Spacer(minLength: 0)
            
            VStack {
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                HStack {
                    
                    
                    Spacer()
                    
                    Button(action: {
                        vm.register()
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
        .overlay {
            if vm.isLoading {
                ProgressView()
            }
        }
    }
}
