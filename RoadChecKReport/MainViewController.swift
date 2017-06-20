//
//  MainViewController.swift
//  RoadChecKReport
//
//  Created by Chang sean on 2017/6/8.
//  Copyright © 2017年 Chang sean. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MainViewController: UIViewController, GMSMapViewDelegate {
    
    //MARK: 宣告
    
    //button tag: 0->report, 1->map, 2->setting
    enum buttonType : Int {
        case report = 0
        case map = 1
        case setting = 2
    }
    
    var placesClient: GMSPlacesClient!
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var zoomLevel : Float = 15.0
    var statusBarHeight:CGFloat = 0.0
    let taiwanCenterCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 23.9740931, longitude: 120.9777142)
    
    let width : CGFloat = UIScreen.main.bounds.width
    let height : CGFloat = UIScreen.main.bounds.height
    
    var canUseHeight : CGFloat = 0.0
    
    let circleButton:UIButton = {
        
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = UIColor(hexString: "#3e426f")
        bt.tag = buttonType.report.rawValue
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
        view.borderWidth = 1.5
        view.borderColor = UIColor(hexString: "#7c82a2")
        
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
        bt.tag = buttonType.map.rawValue
        
        return bt
    }()
    
    let settingButton:UIButton = {
        
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.tag = buttonType.setting.rawValue
        
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
    
    let locationLabel:UILabel = {
        
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textColor = UIColor(hexString: "#ffa700")
        lb.text = "取得位置資訊中..."
        
        return lb
    }()
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        locationManager.requestAlwaysAuthorization()
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBarHeight = statusBar.height
        canUseHeight = height - statusBarHeight
        
        view.backgroundColor = UIColor.white

//        self.locationManagerInit()
        self.setupMapView()
        self.setupBottom()
        self.setupButton()
        self.setupCircleImage()
        self.setupIconAndLabel()
//        self.signOutBT()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkUserAuthorizationStatus()
        self.getCurrentPlace()
    }
    
    func locationManagerInit() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.delegate = self
    }
    
    //MARK: InterFace Setup
    
    func setupMapView() {
        
        let myCoordinate = locationManager.location?.coordinate
        
        let camera = GMSCameraPosition.camera(withLatitude: myCoordinate?.latitude ?? taiwanCenterCoordinate.latitude, longitude: myCoordinate?.longitude ?? taiwanCenterCoordinate.longitude, zoom: 6.0)
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
        
        mapButton.widthAnchor.constraint(equalToConstant: width - ((width * 0.25) + (height * 0.1))).isActive = true
        mapButton.heightAnchor.constraint(equalToConstant: height * 0.1).isActive = true
        mapButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: width * 0.25).isActive = true
        
        mapButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        
        settingButton.widthAnchor.constraint(equalToConstant: height * 0.1).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: height * 0.1).isActive = true
        settingButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
        settingButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        
        circleButton.layer.cornerRadius = (width * 0.25) / 2
        
        circleButton.widthAnchor.constraint(equalToConstant: width * 0.25).isActive = true
        circleButton.heightAnchor.constraint(equalToConstant: width * 0.25).isActive = true
//        circleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circleButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        circleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3).isActive = true
    }
    
    func setupIconAndLabel() {
        
//        mapButton.addSubview(mapIcon)
        mapButton.addSubview(locationLabel)
        settingButton.addSubview(settingIcon)
        
        locationLabel.topAnchor.constraint(equalTo: self.mapButton.topAnchor).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: self.mapButton.leftAnchor, constant: 10).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: self.mapButton.rightAnchor).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: self.mapButton.bottomAnchor).isActive = true
        
        settingIcon.widthAnchor.constraint(equalToConstant: (height * 0.1) * 0.6).isActive = true
        settingIcon.heightAnchor.constraint(equalToConstant: (height * 0.1) * 0.6).isActive = true
        settingIcon.centerYAnchor.constraint(equalTo: self.settingButton.centerYAnchor).isActive = true
        settingIcon.centerXAnchor.constraint(equalTo: self.settingButton.centerXAnchor).isActive = true
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
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let my = locationManager.location else {
            return
        }
//        let my = locationManager.location
        
        //button tag: 0->report, 1->map, 2->setting
        if sender.tag == buttonType.map.rawValue {
            print("map")
        } else if sender.tag == buttonType.setting.rawValue {
            print("setting")
        } else if sender.tag == buttonType.report.rawValue {
            print("user ID: \(uid)")
            print("latitude:\(my.coordinate.latitude), longitude:\(my.coordinate.longitude)")
            
            self.getCurrentPlace()
        }
    }
    
    func getCurrentPlace() {
        
        placesClient.currentPlace { (placeLikelihoodList, error) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                if let placeLikelihoodList = placeLikelihoodList {
                
                    let place = placeLikelihoodList.likelihoods.first?.place
                    if let place = place {
                        print("place: \(place.name)")
                        let address = place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n")
                        print("address: \(address!)")
                        self.locationLabel.text = address
                    }
                }
            }
        }
    }
    
    
    func checkUserAuthorizationStatus() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 20
        
        locationManager.delegate = self
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus()
            == .notDetermined {
            // 取得定位服務授權
            locationManager.requestAlwaysAuthorization()
            
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController,animated: true, completion: nil)
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
        
        self.getCurrentPlace()
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
    
    // 当这个区域开始被监听的时候,就会来到didStartMonitoringFor方法
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
    }
    
    // 进入该区域的时候会来到didEnterRegion方法(动作)
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    // 离开该区域的时候会来到didExitRegion方法(动作)
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
