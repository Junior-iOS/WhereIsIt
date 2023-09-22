//
//  SelectedPlaceDetailView.swift
//  WhereIsIt
//
//  Created by NJ Development on 21/09/23.
//

import SwiftUI
import MapKit

struct SelectedPlaceDetailView: View {
    @Binding var mapItem: MKMapItem?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .trailing) {
                if let mapItem {
                    PlacesView(mapItem: mapItem)
                }
            }
            
            Image(systemName: SFSymbols.xmarkCircleFill.rawValue)
                .padding([.trailing], 10)
                .onTapGesture {
                    mapItem = nil
                }
        }
    }
}

#Preview {
    let apple = Binding<MKMapItem?> { PreviewMock.apple } set: { _ in }
    return SelectedPlaceDetailView(mapItem: apple)
}
