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
    
    private var distance: Measurement<UnitLength>? {
        guard let userLocation = LocationManager.shared.manager.location,
              let destinationLocation = mapItem.placemark.location else {
            return nil
        }
        
        return MapUtilities.calculcateDistance(from: userLocation, to: destinationLocation)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(mapItem.name ?? "")
                .font(.title3)
            Text(address)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let distance {
                Text(distance, formatter: MeasurementFormatter.distance)
            }
        }
    }
    
    private func getAddress(from placemark: MKPlacemark) -> String {
        return "\(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
    }
}

#Preview {
    PlacesView(mapItem: PreviewMock.apple)
        .padding()
}
