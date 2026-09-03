//
//  LogInView.swift
//  twitter-clone (iOS)
//
//  Created by cem on 8/10/21.
//

import SwiftUI

struct LogInView: View {
    @StateObject private var vm: LoginViewModel

    init(authService: AuthServiceProtocol) {
        self._vm = StateObject(wrappedValue: LoginViewModel(service: authService))
    }

    var body: some View {
        ZStack {
            if !vm.emailDone {
                VStack {
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

                        Text("To get started first enter your phone, email, or @username")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top)

                        CustomAuthTextField(placeHolder: "Phone, email, or username", text: $vm.email)
                    }

                    Spacer(minLength: 0)

                    VStack {
                        Button(action: {
                            vm.continueToPasswordStep()
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

                        Text("Enter your password")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top)

                        CustomAuthTextField(placeHolder: "Password", text: $vm.password)
                    }

                    Spacer(minLength: 0)

                    VStack {
                        Button(action: {
                            vm.login()
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

            if vm.isLoading {
                ProgressView()
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(authService: AuthService())
    }
}
