//
//  SearchView.swift
//  twitter-clone (iOS)
//
//  Created by cem on 8/1/21.
//

import SwiftUI

struct SearchView : View {
    
    var body : some View{
        
        VStack {
            
            List(0..<9){i in
                
                SearchCell(tag: "hello", tweets: "hello")
                
            }
            
        }
    }
}

struct SearchCell : View {
    
    var tag = ""
    var tweets = ""
    
    var body : some View{
        
        VStack(alignment : .leading,spacing : 5){
            
            Text(tag).fontWeight(.heavy)
            Text(tweets + " Tweets").fontWeight(.light)
        }
    }
}
