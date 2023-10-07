//
//  ContentView.swift
//  Location Motion 2023
//
//  Created by michael isbell on 10/4/23.
//

import SwiftUI
import CoreLocation


struct ContentView: View {
    @StateObject var locationDataManager = LocationDataManager()
    var body: some View {
        VStack {
            switch locationDataManager.locationManager!.authorizationStatus {
            case .authorizedWhenInUse:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
                Text("Your current location is:")
                Text("Latitude: \(locationDataManager.locationManager!.location?.coordinate.latitude.description ?? "Error loading")")
                Text("Longitude: \(locationDataManager.locationManager!.location?.coordinate.longitude.description ?? "Error loading")")
                
            case .restricted, .denied:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorized
                Text("Current location data was restricted or denied.")
            case .notDetermined:        // Authorization not determined yet.
                Text("Finding your location...")
                ProgressView()
                
            default:
                ProgressView()
            }
            Text("...we're good")
            
            // create buttons to start and stop updates
            
            Button(action: {
                locationDataManager.locationManager!.startUpdatingLocation()
            }, label: {
                Text("start getting updates")
                    .background(Color.green)
            })
            
            Button(action: {
                locationDataManager.locationManager!.stopUpdatingLocation()
            }, label: {
                Text("STOP getting updates")
                    .background(Color.red)
            })
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
