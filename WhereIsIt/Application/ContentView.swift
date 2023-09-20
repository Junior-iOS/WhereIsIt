//
//  ContentView.swift
//  WhereIsIt
//
//  Created by NJ Development on 14/09/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var locationManager = LocationManager.shared
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selectedDetend: PresentationDetent = .fraction(0.15)
    
    @State private var query: String = ""
    @State private var isSearching = false
    @State private var mapItems: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        ZStack {
            Map(position: $position) {
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
                        TextField("Search", text: $query)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .onSubmit {
                                isSearching = true
                            }
                        
                        List(mapItems, id: \.self) { mapItem in
                            PlacesView(mapItem: mapItem)
                        }
                        
                        Spacer()
                    } // MARK: - VSTACK
                    .presentationDetents([.fraction(0.15), .medium, .large], selection: $selectedDetend)
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled()
            }) // MARK: - SHEET
        } // MARK: ZSTACK
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
