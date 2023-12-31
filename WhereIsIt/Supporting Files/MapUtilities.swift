//
//  MapUtilities.swift
//  WhereIsIt
//
//  Created by NJ Development on 16/09/23.
//

import Foundation
import MapKit

final class MapUtilities {
    static func search(term: String, region: MKCoordinateRegion?) async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = term
        request.resultTypes = .pointOfInterest
        
        guard let region else { return [] }
        request.region = region
        
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        return response.mapItems
    }
    
    static func calculateDistance(from firstLocation: CLLocation, to secondLocation: CLLocation) -> Measurement<UnitLength> {
        let meters = firstLocation.distance(from: secondLocation)
        return Measurement(value: meters, unit: .meters)
    }
    
    static func calculateDirections(from firstLocation: MKMapItem, to secondLocation: MKMapItem) async throws -> MKRoute? {
        let directionsRequest = MKDirections.Request()
        directionsRequest.transportType = .automobile
        directionsRequest.source = firstLocation
        directionsRequest.destination = secondLocation
        
        let directions = MKDirections(request: directionsRequest)
        let response = try? await directions.calculate()
        return response?.routes.first
    }
    
    static func makePhoneCall(_ number: String) {
        if let url = URL(string: "tel://\(number)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
