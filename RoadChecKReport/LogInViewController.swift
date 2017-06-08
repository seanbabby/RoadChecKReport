//
//  LogInViewController.swift
//  RoadChecKReport
//
//  Created by Chang sean on 2017/6/7.
//  Copyright © 2017年 Chang sean. All rights reserved.
//

//更改FB登入文字
//請到 FBSDKLoginKit -> FBSDKLoginButton -> - (NSString *)_longLogInTitle

import UIKit
import FBSDKLoginKit
import FacebookLogin
import Firebase


class LogInViewController: UIViewController {
    
    var onLogin = UILabel()
    
    var indicator:UIActivityIndicatorView?
    
    let FBLogInBT:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hexString: "#3b5998")
        button.setTitle("使用 Facebook 登入", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        return button
    }()
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.setupLogInBT()
        self.setOnLoginningLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser?.uid != nil {
            
            print("uid: ", Auth.auth().currentUser?.uid as Any)
            
            DispatchQueue.main.async {
                let mainVC = MainViewController()
            
                UIApplication.shared.keyWindow?.rootViewController = mainVC
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.onLogin.isHidden = true
        }
    }
    
    func setupLogInBT() {
        
        FBLogInBT.clipsToBounds = true
        FBLogInBT.layer.cornerRadius = (height * 0.2) / 10
        FBLogInBT.addTarget(self, action: #selector(loginBTClick), for: .touchUpInside)
        
        view.addSubview(FBLogInBT)
        
        FBLogInBT.widthAnchor.constraint(equalToConstant: width * 0.7).isActive = true
        FBLogInBT.heightAnchor.constraint(equalToConstant: height * 0.08).isActive = true
        FBLogInBT.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        FBLogInBT.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func loginBTClick() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .userFriends, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                
                self.onLogin.isHidden = false
                self.setupIndicator()
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                Auth.auth().signIn(with: credential) { (user, error) in
                    
                    if let error = error {
                        print("error : \(error)")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.indicator?.stopAnimating()
                    
                        let mainVC = MainViewController()
                    
                        UIApplication.shared.keyWindow?.rootViewController = mainVC
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func setupIndicator() {
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.indicator?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator!)
        self.indicator?.startAnimating()
        
        self.indicator?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.indicator?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.indicator?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.indicator?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setOnLoginningLabel() {
        onLogin = UILabel()
        onLogin.isHidden = true
        onLogin.translatesAutoresizingMaskIntoConstraints = false
        onLogin.textAlignment = .center
        onLogin.textColor = UIColor.white
        onLogin.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 0.9)
        onLogin.clipsToBounds = true
        onLogin.layer.cornerRadius = (height*0.2)/10
        onLogin.text = "登入中   請稍候"
        self.view.addSubview(onLogin)
        
        onLogin.widthAnchor.constraint(equalToConstant: width * 0.7).isActive = true
        onLogin.heightAnchor.constraint(equalToConstant: height * 0.08).isActive = true
        onLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        onLogin.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
}
