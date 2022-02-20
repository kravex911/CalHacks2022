//
//  MapViewModel.swift
//  HopefullyThefinalOne
//
//  Created by Umar Hassan on 2022-02-19.
//

import Foundation
import MapKit

enum MapDetails {
    static let startingLocation  = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.8911054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    var locationManager: CLLocationManager?
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    @Published var location = MapDetails.startingLocation
    @Published var pointsOI: [Place] = []
    
    func checkLocationEnabled (){
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
//            checkLocationAuthorization()
            locationManager!.delegate = self
        } else {
            print("Show alert")
        }
    }
    
    private func checkLocationAuthorization (){
        guard let locationManager = locationManager else {
            return
        }
        
        
        switch locationManager.authorizationStatus {
            
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("SOmething is worng here")
        case .denied:
            print("SOmething is worng here")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate , span: MapDetails.defaultSpan)
            location = locationManager.location!.coordinate
            let test = MKLocalPointsOfInterestRequest.init(center: location, radius: 10000)
            test.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: [MKPointOfInterestCategory.publicTransport, MKPointOfInterestCategory.parking]))
            let search = MKLocalSearch(request: test)
            search.start{ [self]  (response, error) in
                guard error == nil else {
//                    self.displaySearchError(error)
                    print("Error")
                    return
                }
                guard let response = response else {
                    return
                }
                print(response.mapItems)
                
                for item in response.mapItems{
                    
                    let itemName=item.placemark.name!
                    self.pointsOI.append(Place(
                        name: itemName,
                        coordinate: item.placemark.coordinate,
                        icon: itemName.lowercased().contains("stop") || itemName.lowercased().contains("transit") ? IconType.stop : IconType.parking))
                }
                self.pointsOI.append(Place(
                    name: "You",
                    coordinate: location,
                    icon: .yourself))
                
                // Used when setting the map's region in `prepareForSegue`.
//                if let updatedRegion = response?.boundingRegion {
//                    self.boundingRegion = updatedRegion
//                }
            }
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

struct Place: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let icon: IconType
}


enum IconType {
    case yourself , stop, parking
}
