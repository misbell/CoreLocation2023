//
//  LocationDataManager.swift
//  Location Motion 2023
//
//  Created by michael isbell on 10/4/23.
//

import Foundation
import CoreLocation

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager : CLLocationManager? = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        
        // consider walking apps vs driving apps, distance resolution etc
        
        guard let locmanager = locationManager else { return } // actually fail and close the app
        
        locmanager.delegate = self
        locmanager.activityType = .fitness // or automotive, airborne, other, // fitness, indoor positioning disabled
        locmanager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // most accurate and power intensive
        locmanager.distanceFilter = 1 // 1 meter // standard servics only, not visits or significantchange
        locmanager.allowsBackgroundLocationUpdates = true
        
        // accuracy within ten meters, hundred, kilometer, three kilometers
        
        if #available(iOS 14.0, *) {
            
            // set this on the context view
            
            switch locmanager.accuracyAuthorization {
            case .fullAccuracy:
                print("Full Accuracy")
            case .reducedAccuracy:
                print("Reduced Accuracy")
            @unknown default:
                print("Unknown Precise Location...")
            }
            
        }
        
        
    }
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            authorizationStatus = .authorizedWhenInUse
            //locationManager!.requestLocation()
            locationManager!.startUpdatingLocation()
            break
            
        case .restricted:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .restricted
            break
            
        case .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .denied
            break
            
        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization() // note with uikit this was done in ViewDidLoad
            // or
            // manager.requestAlwaysAuthorization()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            
        }
        
        print("LocationManager didUpdateLocations: numberOfLocation: \(locations.count)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        locations.forEach {
            (location) in
            print("LocationManager didUpdateLocations: \(dateFormatter.string(from: location.timestamp)); \(location.coordinate.latitude), \(location.coordinate.longitude)")
            print("LocationManager altitude: \(location.altitude)")
            print("LocationManager floor?.level: \(location.floor?.level)")
            print("LocationManager horizontalAccuracy: \(location.horizontalAccuracy)")
            print("LocationManager verticalAccuracy: \(location.verticalAccuracy)")
            print("LocationManager speedAccuracy: \(location.speedAccuracy)")
            print("LocationManager speed: \(location.speed)")
            print("LocationManager timestamp: \(location.timestamp)")
            print("LocationManager courseAccuracy: \(location.courseAccuracy)") // 13.4
            print("LocationManager course: \(location.course)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError \(error.localizedDescription)")
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            // To prevent forever looping of `didFailWithError` callback
            locationManager?.stopMonitoringSignificantLocationChanges()
            return
        }
        
        
    }
    
}
    
    // locationManager.startUpdatingLocation()
    // locationManager.startMonitoringSignificantLocationChanges()
    // locationManager.startMonitoringVisits()
    // locationManager.startMonitoringLocationPushes()
    // locationManager.stopUpdatingLocation()
    // locationManager.startMonitoringLocationPushes(completion: <#T##((Data?, Error?) -> Void)?##((Data?, Error?) -> Void)?##(Data?, Error?) -> Void#>)
