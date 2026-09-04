//
//  WelcomeView.swift
//  twitter-clone (iOS)
//
//  Created by cem on 8/10/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width

            VStack(spacing: 0) {
                HStack {
                    Spacer(minLength: 0)

                    Image("Twitter")
                        .resizable()
                        .scaledToFill()
                        .padding(.trailing)
                        .frame(width: 20, height: 20)

                    Spacer(minLength: 0)
                }

                Spacer(minLength: 0)

                Text("See what's happening in the world right now.")
                    .font(.system(size: 30, weight: .heavy, design: .default))
                    .frame(width: width * 0.9, alignment: .center)

                Spacer(minLength: 0)

                VStack(alignment: .center, spacing: 10) {
                    Button(action: {
                        print("Hello button tapped!")
                    }) {
                        HStack(spacing: -4) {
                            Image("google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)

                            Text("Continue with Google")
                                .fontWeight(.bold)
                                .font(.title3)
                                .foregroundColor(.black)
                                .padding()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(Color.black, lineWidth: 1)
                                .opacity(0.3)
                                .frame(width: 320, height: 60, alignment: .center)
                        )
                    }

                    Button(action: {
                        print("Hello button tapped!")
                    }) {
                        HStack(spacing: -4) {
                            Image("apple")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)

                            Text("Continue with Apple")
                                .fontWeight(.bold)
                                .font(.title3)
                                .foregroundColor(.black)
                                .padding()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(Color.black, lineWidth: 1)
                                .opacity(0.3)
                                .frame(width: 320, height: 60, alignment: .center)
                        )
                    }

                    HStack {
                        Rectangle()
                            .foregroundColor(.gray)
                            .opacity(0.3)
                            .frame(width: width * 0.35, height: 1)

                        Text("Or")
                            .foregroundColor(.gray)

                        Rectangle()
                            .foregroundColor(.gray)
                            .opacity(0.3)
                            .frame(width: width * 0.35, height: 1)
                    }

                    NavigationLink(value: AuthRoute.register) {
                        RoundedRectangle(cornerRadius: 36)
                            .foregroundColor(Color(red: 29 / 255, green: 161 / 255, blue: 242 / 255))
                            .frame(width: 320, height: 60, alignment: .center)
                            .overlay(
                                Text("Create account")
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding()
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("By signing up, you agree to our Terms, Privacy Policy, and Cookie Use.")
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)

                    HStack(spacing: 2) {
                        Text("Have an account already? ")
                        NavigationLink(value: AuthRoute.login) {
                            Text("Log in")
                                .foregroundColor(Color(red: 29 / 255, green: 161 / 255, blue: 242 / 255))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
