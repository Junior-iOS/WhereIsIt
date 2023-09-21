//
//  PreviewMock.swift
//  WhereIsIt
//
//  Created by NJ Development on 20/09/23.
//

import Foundation
import MapKit
import Contacts

struct PreviewMock {
    static var apple: MKMapItem {
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let addressDict: [String: Any] = [
            CNPostalAddressStreetKey: "1 Infinite Loop",
            CNPostalAddressCityKey: "Cupertino",
            CNPostalAddressStateKey: "CA",
            CNPostalAddressPostalCodeKey: "95014",
            CNPostalAddressCountryKey: "United States",
        ]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Apple Inc."
        return mapItem
    }
}
