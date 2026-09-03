//
//  SlideMenuItems.swift
//  twitter-clone (iOS)
//
//  Created by cem on 7/31/21.
//

import SwiftUI

struct MenuButton : View {
    
    var title : String
    
    var body: some View{
        
        HStack(spacing: 15){
            
            // both title and image names are same....
            Image(title)
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)
            
            Text(title)
                .foregroundColor(.black)
            
            Spacer(minLength: 0)
        }
        .padding(.vertical,12)
    }
}

struct FollowView : View {
    
    var count : Int
    var title : String
    
    var body: some View{
    
        HStack {
            
            Text("\(count)")
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(title)
                .foregroundColor(.gray)
        }
    }
}
