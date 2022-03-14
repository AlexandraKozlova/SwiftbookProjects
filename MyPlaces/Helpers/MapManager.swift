//
//  MapManager.swift
//  MyPlaces
//
//  Created by Aleksandra on 23.11.2021.
//

import UIKit
import MapKit

class MapManager {
    
    let locationManager = CLLocationManager()
    let regionInMeters = 5_000.00
    var directionsArray: [MKDirections] = []
    var placeCoordinate: CLLocationCoordinate2D?
    
    func setupPlaceMark(place: Place, map: MKMapView) {
       guard let location = place.location else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { placemarks, error in
            if let error = error {
                print (error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            map.showAnnotations([annotation], animated: true)
            map.selectAnnotation(annotation, animated: true)
        }
    }
    
    func checkLocationServices(map: MKMapView, incomesequeIdentifier: String, closure: () -> ()) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(map: map, incomeSequeIdentifier: incomesequeIdentifier)
            closure()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAllert(title: "Your location is unavailable", message: "Go to settings -> My Places, location")
            }
        }
    }
    
    func checkLocationAuthorization(map: MKMapView, incomeSequeIdentifier: String ) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            if incomeSequeIdentifier == "getAddress" { showUserLocation(map: map) }
            break
        case .denied:
            showAllert(title: "Your location is unavailable", message: "Go to settings -> My Places, location")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAllert(title: "Your location is unavailable", message: "Go to settings -> My Places, location")
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("new case is available")
        }
    }
    
    func showUserLocation(map: MKMapView) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }
    }
    
    func getDirections(for map: MKMapView, previousLocation: (CLLocation) -> ()) {
        guard let location = locationManager.location?.coordinate else {
            showAllert(title: "Error", message: "Location is not found")
            return
        }
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let request = createDirectionRequest(from: location) else {
            showAllert(title: "Error", message: "Destination is not found")
            return
        }
        let direction = MKDirections(request: request)
        resetMapView(withNew: direction, map: map)
        
        direction.calculate { response, error in
            if let error = error {
                print(error)
                return
            }
            guard let response = response else {
                self.showAllert(title: "Error", message: "Destination is not found")
                return
            }
            
            for route in response.routes {
                map.addOverlay(route.polyline)
                map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)  // выбираем видимость всего маршрута на карте
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime
                
                print("Расстояние до места \(distance)км")
                print("Время в пути \(timeInterval)сек")
            }
        }
    }
    
    func createDirectionRequest(from coodrinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coodrinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    func startTrackingUserLocation(for map: MKMapView, and previousLocation: CLLocation?, closure: (_ currentLocation: CLLocation) -> () ) {
        guard let previousLocation = previousLocation else { return }
        let center = getCenterLocation(for: map)
        guard center.distance(from: previousLocation) > 50 else { return }
        closure(center)
    }
    
    func resetMapView(withNew directions: MKDirections, map: MKMapView) {
        map.removeOverlays(map.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map{ $0.cancel() }
        directionsArray.removeAll()
    }
    
    func getCenterLocation(for map: MKMapView) -> CLLocation {
        let latitude = map.centerCoordinate.latitude
        let longitude = map.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func showAllert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true)
    }
}
