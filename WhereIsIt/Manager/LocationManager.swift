//
//  LocationManager.swift
//  WhereIsIt
//
//  Created by NJ Development on 14/09/23.
//

import Foundation
import MapKit
import Observation

enum LocationError: LocalizedError {
    case authorizationDenied
    case authorizationRestricted
    case unknownLocation
    case accessDenied
    case network
    case operationFailed
    
    var description: String {
        switch self {
        case .authorizationDenied:
            NSLocalizedString("Authorization denied", comment: "")
        case .authorizationRestricted:
            NSLocalizedString("Authorization restricted", comment: "")
        case .unknownLocation:
            NSLocalizedString("Unknown location", comment: "")
        case .accessDenied:
            NSLocalizedString("Access denied", comment: "")
        case .network:
            NSLocalizedString("Network failed", comment: "")
        case .operationFailed:
            NSLocalizedString("Operation failed", comment: "")
        }
    }
}

@Observable
final class LocationManager: NSObject {
    static let shared = LocationManager()
    let manager: CLLocationManager = CLLocationManager()
    var region: MKCoordinateRegion = MKCoordinateRegion()
    
    var error: LocationError? = nil
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude,
                                               longitude: $0.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05,
                                       longitudeDelta: 0.05)
            )
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied:
            error = .authorizationDenied
        case .restricted:
            error = .authorizationRestricted
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .locationUnknown:
                self.error = .unknownLocation
            case .denied:
                self.error = .accessDenied
            case .network:
                self.error = .network
            default:
                self.error = .operationFailed
            }
        }
    }
}
