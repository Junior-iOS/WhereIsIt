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
    
    static func calculcateDistance(from firstLocation: CLLocation, to secondLocation: CLLocation) -> Measurement<UnitLength> {
        let meters = firstLocation.distance(from: secondLocation)
        return Measurement(value: meters, unit: .meters)
    }
}
