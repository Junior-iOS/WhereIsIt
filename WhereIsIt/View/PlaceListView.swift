//
//  PlaceListView.swift
//  WhereIsIt
//
//  Created by NJ Development on 21/09/23.
//

import SwiftUI
import MapKit

struct PlaceListView: View {
    let mapItems: [MKMapItem]
    
    private var sortedItems: [MKMapItem] {
        guard let userLocation = LocationManager.shared.manager.location else {
            return mapItems
        }
        
        return mapItems.sorted { lhs, rhs in
            guard let lhsLocation = lhs.placemark.location,
                  let rhsLocation = rhs.placemark.location else {
                return false
            }
            
            let lhsDistance = userLocation.distance(from: lhsLocation)
            let rhsDistance = userLocation.distance(from: rhsLocation)
            
            return lhsDistance < rhsDistance
        }
    }
    
    var body: some View {
        List(mapItems, id: \.self) { mapItem in
            PlacesView(mapItem: mapItem)
        }
    }
}

#Preview {
    PlaceListView(mapItems: [PreviewMock.apple])
}
