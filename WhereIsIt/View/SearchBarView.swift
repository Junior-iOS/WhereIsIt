//
//  SearchBarView.swift
//  WhereIsIt
//
//  Created by NJ Development on 21/09/23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var search: String
    @Binding var isSearching: Bool
    
    var body: some View {
        VStack(spacing: -10) {
            TextField("Search", text: $search)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    isSearching = true
                }
            
            SearchOptions { searchOption in
                search = searchOption
                isSearching = true
            }
            .padding([.leading], 10)
            .padding([.bottom], 20)
        }
    }
}

#Preview {
    SearchBarView(search: .constant("Coffee"), isSearching: .constant(true))
}
