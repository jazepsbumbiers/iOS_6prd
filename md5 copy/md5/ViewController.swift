//
//  ViewController.swift
//  md5
//
//  Created by Jazeps on 29/04/2018.
//  Copyright © 2018 Jazeps. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, SecondViewControllerDelegate, ThirdViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    var myLabel: String = ""
    var hideDesc: Bool = false
    var show10km: Bool = false
    var firstPoint = MKPointAnnotation()
    var secondPoint = MKPointAnnotation()
    var thirdPoint = MKPointAnnotation()
    
    var array: [MKPointAnnotation] = []
    var loadedArray: [MKPointAnnotation] = []
    
    var userPoint = MKPointAnnotation()
    var userLocation = MKPointAnnotation()
    
    var locManager = CLLocationManager()
    
    let directionRequest = MKDirectionsRequest()
    var locMark:MKPlacemark?
    var destMark:MKPlacemark?
    var source:MKMapItem?
    var destination:MKMapItem?
    
    @IBOutlet var filterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstPoint.title = "Vidzemes Augstskola"
        firstPoint.subtitle = "1 punkts"
        firstPoint.coordinate = CLLocationCoordinate2D(latitude: 57.535067, longitude: 25.424228)
        
        secondPoint.title = "Riga"
        secondPoint.subtitle = "2 punkts"
        secondPoint.coordinate = CLLocationCoordinate2D(latitude: 56.9496, longitude: 24.1052)
        
        thirdPoint.title = "Sigulda"
        //thirdPoint.subtitle = "3 punkts"
        thirdPoint.coordinate = CLLocationCoordinate2D(latitude: 57.1496, longitude: 24.8603)
        
        array.append(firstPoint)
        array.append(secondPoint)
        array.append(thirdPoint)
        
        self.mapView.delegate = self
        
        self.locManager.requestAlwaysAuthorization()
        self.locManager.requestWhenInUseAuthorization()
        
        if ( CLLocationManager.locationServicesEnabled() ) {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        mapView.addAnnotation(userPoint)
        
        for i in 0...(array.count-1) {
            var addPoint = false
            
            if ( show10km ) {
                var currentPoint:CLLocation! = CLLocation(latitude: array[i].coordinate.latitude, longitude: array[i].coordinate.longitude)
                var userPointLocation:CLLocation! = CLLocation(latitude: userPoint.coordinate.latitude, longitude: userPoint.coordinate.longitude)
                
                print(userPointLocation.distance(from: currentPoint))
                if ( userPointLocation.distance(from: currentPoint) < 10000 ) {
                    addPoint = true
                }
            }
            else {
                addPoint = true
            }
            
            if ( hideDesc ) {
                if ( array[i].subtitle != nil && !addPoint ) {
                    addPoint = true
                }
                else if ( array[i].subtitle == nil ) {
                    addPoint = false
                }
            }
            
            if ( addPoint ) {
                mapView.addAnnotation(array[i])
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = locManager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        userLocation.title = "Jūsu atrašanās vieta"
        userLocation.coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        mapView.addAnnotation(userLocation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if ( view.annotation?.title != "Jūsu atrašanās vieta" ) {
            mapView.removeOverlays(mapView.overlays)
            let latitude: Double = Double((view.annotation?.coordinate.latitude)!)
            let longitude: Double = Double((view.annotation?.coordinate.longitude)!)
            locMark = MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil)
            destMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil)
            
            source = MKMapItem(placemark: locMark!)
            destination = MKMapItem(placemark: destMark!)
            
            directionRequest.source = source
            directionRequest.destination = destination
            directionRequest.requestsAlternateRoutes = true
            
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate { response, error in
                if let route = response?.routes.first {
                    self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 2
        
        return renderer
    }
    
//    class func plist(_ plist: String) -> Any? {
//        let filePath = Bundle.main.path(forResource: "locations", ofType: "plist")!
//        let data = FileManager.default.contents(atPath: filePath)!
//        return try! PropertyListSerialization.propertyList(from: data, options: [], format: nil)
//    }
    
    func setHideDesc() -> Bool {
        hideDesc = hideDesc ? false : true
        print(hideDesc)
        return hideDesc
        //filterButton.setTitle(hideDesc ? "true" : "false", for: .normal)
    }
    
    func setshow10km() -> Bool {
        show10km = show10km ? false : true
        print(show10km)
        return show10km
    }
    
    func setUserLatitude(latitude: Double) -> Double {
        if ( latitude == -999 ) {
            return userPoint.coordinate.latitude
        }
        else {
            userPoint.coordinate.latitude = latitude
            return userPoint.coordinate.latitude
        }
    }
    
    func setUserLongitude(longitude: Double) -> Double {
        if ( longitude == -999 ) {
            return userPoint.coordinate.longitude
        }
        else {
            userPoint.coordinate.longitude = longitude
            return userPoint.coordinate.longitude
        }
    }
    

    func addPin(name: String, subtitle: String, latitude: Double, longitude: Double) {
        var newPoint = MKPointAnnotation()
        newPoint.title = name
        newPoint.subtitle = subtitle
        newPoint.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        array.append(newPoint)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kautkads", let vc = segue.destination as? ViewController2 {
            vc.delegate = self
        }
        else if segue.identifier == "addpin", let vc = segue.destination as? ViewController3 {
            vc.delegate = self
        }
    }


}





