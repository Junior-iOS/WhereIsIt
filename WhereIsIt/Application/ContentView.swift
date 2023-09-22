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
    
    var body: some View {
        ZStack {
            Map(position: $position, selection: $selectedMapItem) {
                ForEach(mapItems, id: \.self) { mapItem in
                    Marker(item: mapItem)
                }
                UserAnnotation()
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
                            
                            LookAroundPreview(initialScene: lookAroundScene)
                                .task(id: selectedMapItem) {
                                    lookAroundScene = nil
                                    
                                    if let selectedMapItem {
                                        let request = MKLookAroundSceneRequest(mapItem: selectedMapItem)
                                        lookAroundScene = try? await request.scene
                                    }
                                }
                        }
                        Spacer()
                    }
                    .presentationDetents([.fraction(0.15), .medium, .large])
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled()
            }) // MARK: - SHEET
        } // MARK: ZSTACK
        
        .onChange(of: selectedMapItem, {
            displayMode = selectedMapItem != nil ? .detail : .list
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
}

#Preview {
    ContentView()
}
