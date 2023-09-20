//
//  MKCoordinateRegion+Extensions.swift
//  WhereIsIt
//
//  Created by NJ Development on 16/09/23.
//

import Foundation
import MapKit

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center.latitude == rhs.center.latitude && lhs.span.latitudeDelta == rhs.span.longitudeDelta && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
    
    static var coffee: MKCoordinateRegion {
        MKCoordinateRegion(center: .starbucksMaia, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    static var restaurant: MKCoordinateRegion {
        MKCoordinateRegion(center: .outbackInternational, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
}
