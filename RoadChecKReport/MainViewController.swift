//
//  MainViewController.swift
//  RoadChecKReport
//
//  Created by Chang sean on 2017/6/8.
//  Copyright © 2017年 Chang sean. All rights reserved.
//

import UIKit
import GoogleMaps

class MainViewController: UIViewController {
    
    let bottomView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#3e426f")
        
        return view
    }()
    
    var mapView:GMSMapView = {
        let map = GMSMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        self.setupMapView()
        self.setupBottom()
//        self.signOutBT()
    }
    
    func setupMapView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), camera: camera)
        mapView.isMyLocationEnabled = true
        
        view.addSubview(mapView)
        self.setupMapViewContranits()
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    func setupMapViewContranits() {
        
        mapView.widthAnchor.constraint(equalToConstant: width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: height * 0.8).isActive = true
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
