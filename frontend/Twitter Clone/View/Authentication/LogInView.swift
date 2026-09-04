//
//  LogInView.swift
//  twitter-clone (iOS)
//
//  Created by cem on 8/10/21.
//

import SwiftUI

struct LogInView: View {
    
    @ObservedObject var vm: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var emailDone = false

    var body: some View {
        ZStack {
            if !emailDone {
                VStack {
                    VStack {

                        Text("To get started first enter your phone, email, or @username")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top)

                        CustomAuthTextField(placeHolder: "Phone, email, or username", text: $email)
                    }

                    Spacer(minLength: 0)

                    VStack {
                        Button(action: {
                            continueToPasswordStep()
                        }, label: {
                            Capsule()
                                .frame(width: 360, height: 40, alignment: .center)
                                .foregroundColor(Color(red: 29 / 255, green: 161 / 255, blue: 242 / 255))
                                .overlay(Text("Next").foregroundColor(.white))
                        })
                        .padding(.bottom, 4)

                        Text("Forgot password?")
                            .foregroundColor(.blue)
                    }
                }
            } else {
                VStack {
                    VStack {

                        Text("Enter your password")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top)

                        CustomAuthTextField(placeHolder: "Password", text: $password)
                    }

                    Spacer(minLength: 0)

                    VStack {
                        Button(action: {
                            vm.login(email: email, password: password)
                        }, label: {
                            Capsule()
                                .frame(width: 360, height: 40, alignment: .center)
                                .foregroundColor(Color(red: 29 / 255, green: 161 / 255, blue: 242 / 255))
                                .overlay(Text("Log in").foregroundColor(.white))
                        })
                        .padding(.bottom, 4)

                        Text("Forgot password?")
                            .foregroundColor(.blue)
                    }
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
    
    func continueToPasswordStep() {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            AlertManager.shared.showAlert(message: "Please enter your email or username.")
            return
        }

        withAnimation {
            emailDone = true
        }
    }
}
