//
//  SearchOptions.swift
//  WhereIsIt
//
//  Created by NJ Development on 20/09/23.
//

import SwiftUI

struct SearchOptions: View {
    let searchOptions = [
        "Restaurants": SFSymbols.forkKnife.rawValue,
        "Coffee": SFSymbols.cupAndSaucerFill.rawValue,
        "Hotels": SFSymbols.bedDoubleFill.rawValue,
        "Gas": SFSymbols.fuelPumpFill.rawValue
    ]
    
    var onSelected: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(searchOptions.sorted(by: >), id: \.key) { key, value in
                    Button(action: {
                        onSelected(key)
                    }, label: {
                        HStack {
                            Image(systemName: value)
                            Text(key)
                        }
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 236/255, green: 240/255, blue: 241/255, opacity: 1.0))
                    .foregroundStyle(.black)
                    .padding(4)
                }
            } // HSTACK
        } // SCROLL VIEW
    }
}

#Preview {
    SearchOptions(onSelected: { _ in })
}
