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
    
    //MARK: 宣告
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var zoomLevel : Float = 15.0
    var statusBarHeight:CGFloat = 0.0
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var canUseHeight:CGFloat = 0.0
    
    let circleButton:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = UIColor(hexString: "#3e426f")
        bt.tag = 0
        bt.borderWidth = 2
        bt.borderColor = UIColor(hexString: "#7c82a2")
        
        return bt
    }()
    
    let circleImageView:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Exclamation")
        
        return image
    }()
    
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
    
    let mapButton:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.tag = 1
        
        return bt
    }()
    
    let settingButton:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.tag = 2
        
        return bt
    }()
    
    let mapIcon:UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "map")
        
        return icon
    }()
    
    let settingIcon:UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "setting")
        
        return icon
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBarHeight = statusBar.height
        canUseHeight = height - statusBarHeight
        
        view.backgroundColor = UIColor.white

        self.locationManagerInit()
        self.setupMapView()
        self.setupBottom()
        self.setupButton()
        self.setupCircleImage()
        self.setupIcon()
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
    //MARK: InterFace Setup
    
    func setupMapView() {
        
        let my = locationManager.location?.coordinate
        
        let camera = GMSCameraPosition.camera(withLatitude: (my?.latitude)!, longitude: (my?.longitude)!, zoom: 6.0)
        mapView.camera = camera
        
        view.addSubview(mapView)
        
        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
        
        mapView.widthAnchor.constraint(equalToConstant: width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: height * 0.9 - statusBarHeight).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
    }
    
    func setupBottom() {
        
        view.addSubview(bottomView)
        
        bottomView.widthAnchor.constraint(equalToConstant: width).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: height * 0.1).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupButton() {
        
        mapButton.addTarget(self, action: #selector(buttontClick), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(buttontClick), for: .touchUpInside)
        circleButton.addTarget(self, action: #selector(buttontClick), for: .touchUpInside)
        
        bottomView.addSubview(mapButton)
        bottomView.addSubview(settingButton)
        view.addSubview(circleButton)
        
        mapButton.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        mapButton.heightAnchor.constraint(equalToConstant: height * 0.1).isActive = true
        mapButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        mapButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        
        settingButton.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: height * 0.1).isActive = true
        settingButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
        settingButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        
        circleButton.layer.cornerRadius = (width * 0.25) / 2
        
        circleButton.widthAnchor.constraint(equalToConstant: width * 0.25).isActive = true
        circleButton.heightAnchor.constraint(equalToConstant: width * 0.25).isActive = true
        circleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3).isActive = true
    }
    
    func setupIcon() {
        
        mapButton.addSubview(mapIcon)
        settingButton.addSubview(settingIcon)
        
        mapIcon.widthAnchor.constraint(equalToConstant: (height * 0.1) * 0.7).isActive = true
        mapIcon.heightAnchor.constraint(equalToConstant: (height * 0.1) * 0.7).isActive = true
        mapIcon.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        mapIcon.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: -(width / 3.5)).isActive = true
        
        settingIcon.widthAnchor.constraint(equalToConstant: (height * 0.1) * 0.7).isActive = true
        settingIcon.heightAnchor.constraint(equalToConstant: (height * 0.1) * 0.7).isActive = true
        settingIcon.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        settingIcon.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: width / 3.5).isActive = true
    }
    
    func setupCircleImage() {
        
        circleButton.addSubview(circleImageView)
        
        circleImageView.widthAnchor.constraint(equalToConstant: (width * 0.25) * 0.7).isActive = true
        circleImageView.heightAnchor.constraint(equalToConstant: (width * 0.25) * 0.7).isActive = true
        circleImageView.centerXAnchor.constraint(equalTo: circleButton.centerXAnchor).isActive = true
        circleImageView.centerYAnchor.constraint(equalTo: circleButton.centerYAnchor).isActive = true
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
    //MARK: Function
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
    
    func buttontClick(sender: UIButton) {
        
        if sender.tag == 1 {
            print("map")
        } else if sender.tag == 2 {
            print("setting")
        } else if sender.tag == 0 {
            print("report")
        }
    }
    
    
}




    //MARK: Extension
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
