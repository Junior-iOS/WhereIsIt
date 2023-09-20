//
//  PlacesView.swift
//  WhereIsIt
//
//  Created by NJ Development on 20/09/23.
//

import SwiftUI
import MapKit

struct PlacesView: View {
    let mapItem: MKMapItem
    
    private var address: String {
        let placemark = mapItem.placemark
        return getAddress(from: placemark)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(mapItem.name ?? "")
                .font(.title3)
            Text(address)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func getAddress(from placemark: MKPlacemark) -> String {
        return "\(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
    }
}

//#Preview {
//    PlacesView()
//}
