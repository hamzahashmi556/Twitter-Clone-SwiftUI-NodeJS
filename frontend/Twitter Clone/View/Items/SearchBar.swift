//
//  SearchBar.swift
//  twitter-clone (iOS)
//
//  Created by cem on 8/1/21.
//

import SwiftUI

struct SearchBar : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        
        let search = UISearchBar()
        return search
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
    }
}
