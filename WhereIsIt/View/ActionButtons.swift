//
//  ActionButtons.swift
//  WhereIsIt
//
//  Created by NJ Development on 21/09/23.
//

import SwiftUI
import MapKit

struct ActionButtons: View {
    let mapItem: MKMapItem
    
    var body: some View {
        HStack {
            if let phone = mapItem.phoneNumber {
                Button(action: {
                    let numericPhoneNumber = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                    MapUtilities.makePhoneCall(numericPhoneNumber)
                }, label: {
                    HStack {
                        Image(systemName: SFSymbols.phoneFill.rawValue)
                        Text("Call")
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            
            Button(action: {
                MKMapItem.openMaps(with: [mapItem])
            }, label: {
                HStack {
                    Image(systemName: SFSymbols.carCircleFill.rawValue)
                    Text("Take me there")
                }
            })
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
    }
}

#Preview {
    ActionButtons(mapItem: PreviewMock.apple)
}
