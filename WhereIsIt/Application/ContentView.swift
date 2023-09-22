//
//  ContentView.swift
//  WhereIsIt
//
//  Created by NJ Development on 14/09/23.
//

import SwiftUI
import MapKit

enum DisplayMode {
    case list
    case detail
}

struct ContentView: View {
    @State private var locationManager = LocationManager.shared
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selectedDetend: PresentationDetent = .fraction(0.15)
    
    @State private var query: String = ""
    @State private var isSearching = false
    
    @State private var mapItems: [MKMapItem] = []
    @State private var selectedMapItem: MKMapItem?
    
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var displayMode: DisplayMode = .list
    @State private var lookAroundScene: MKLookAroundScene?
    
    @State private var route: MKRoute?
    
    var body: some View {
        ZStack {
            Map(position: $position, selection: $selectedMapItem) {
                ForEach(mapItems, id: \.self) { mapItem in
                    Marker(item: mapItem)
                }
                UserAnnotation()
                
                // DRAW ROUTE LINE
                if let route {
                    MapPolyline(route)
                        .stroke(.blue, lineWidth: 5)
                }
            }
            .onChange(of: locationManager.region) {
                position = .region(locationManager.region)
            }
            .mapControls{
                MapCompass()
                MapUserLocationButton()
                MapScaleView()
            }
            .sheet(isPresented: .constant(true), content: {
                VStack {
                    Spacer()
                    switch displayMode {
                    case .list:
                        SearchBarView(search: $query, isSearching: $isSearching)
                        PlaceListView(mapItems: mapItems, selectedMapItem: $selectedMapItem)
                    case .detail:
                        SelectedPlaceDetailView(mapItem: $selectedMapItem)
                            .padding()
                        
                        if selectedDetend == .medium || selectedDetend == .large {
                            if let selectedMapItem {
                                ActionButtons(mapItem: selectedMapItem)
                            }
                            
                            LookAroundPreview(initialScene: lookAroundScene)
                                .task(id: selectedMapItem) {
                                    lookAroundScene = nil
                                    
                                    if let selectedMapItem {
                                        let request = MKLookAroundSceneRequest(mapItem: selectedMapItem)
                                        lookAroundScene = try? await request.scene
                                    }
                                }
                        }
                    }
                    Spacer()
                }
                .presentationDetents([.fraction(0.15), .medium, .large], selection: $selectedDetend)
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .interactiveDismissDisabled()
            }) // MARK: - SHEET
        } // MARK: ZSTACK
        
        .onChange(of: selectedMapItem, {
            if selectedMapItem != nil {
                displayMode = .detail
                calculateDirectionsRequest()
            } else {
                displayMode = .list
                isSearching = false
                route = nil
            }
        })
        
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .task(id: isSearching, {
            await performSearch()
        })
    }
    
    private func performSearch() async {
        do {
            mapItems = try await MapUtilities.search(term: query, region: visibleRegion)
            print(mapItems)
        } catch {
            mapItems = []
            print(error.localizedDescription)
        }
        
        isSearching = false
    }
    
    private func calculateDirectionsRequest() {
        route = nil
        
        if let selectedMapItem {
            guard let userLocation = locationManager.manager.location else { return }
            let startingMapItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
            
            Task {
                route = try await MapUtilities.calculateDirections(from: startingMapItem, to: selectedMapItem)
            }
        }
    }
}

#Preview {
    ContentView()
}
