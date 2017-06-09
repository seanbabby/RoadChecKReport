//
//  MainViewController.swift
//  RoadChecKReport
//
//  Created by Chang sean on 2017/6/8.
//  Copyright © 2017年 Chang sean. All rights reserved.
//

import UIKit
import GoogleMaps

class MainViewController: UIViewController, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var zoomLevel : Float = 15.0
    
    let bottomView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#3e426f")
        
        return view
    }()
    
    let mapView:GMSMapView = {
        let map = GMSMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        
        //can put settings here
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        map.settings.rotateGestures = false
        map.settings.tiltGestures = false
        
        return map
    }()
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        self.locationManagerInit()
        self.setupMapView()
        self.setupBottom()
//        self.signOutBT()
    }
    
    func locationManagerInit() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func setupMapView() {
        
        let my = locationManager.location?.coordinate
        
        let camera = GMSCameraPosition.camera(withLatitude: (my?.latitude)!, longitude: (my?.longitude)!, zoom: 6.0)
        mapView.camera = camera
        
        view.addSubview(mapView)
        self.setupMapViewContranits()
        
        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
    }
    
    func setupMapViewContranits() {
        
        mapView.widthAnchor.constraint(equalToConstant: width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: height * 0.9).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func setupBottom() {
        
        view.addSubview(bottomView)
        
        bottomView.widthAnchor.constraint(equalToConstant: width).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: height * 0.1).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func signOutBT() {
        
        let bt = UIButton(type: .system)
        
        bt.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        bt.center = view.center
        bt.backgroundColor = UIColor.blue
        bt.setTitle("Sign Out", for: .normal)
        bt.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        
        view.addSubview(bt)
    }
    
    func signOut() {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            let loginVC = LogInViewController()
            
            UIApplication.shared.keyWindow?.rootViewController = loginVC
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}
