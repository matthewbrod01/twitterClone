//
//  LoginViewController.swift
//  Twitter
//
//  Created by Matthew Rodriguez on 2/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var viewForLogin: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure appearance for login button
        viewForLogin.layer.borderWidth = 1
        viewForLogin.layer.cornerRadius = 5
        viewForLogin.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.cornerRadius = 5
        
        // add tap functionality to twitter icon
        let didTapIcon = UITapGestureRecognizer(target: self, action: #selector(loginToHomePage))
        loginIcon.isUserInteractionEnabled = true
        loginIcon.addGestureRecognizer(didTapIcon)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // If login data persists, show Home Screen immediately
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
 
    
    @IBAction func onTapLogin(_ sender: Any) {
        loginToHomePage()
    }
    
    /* When icon or button is tapped, this runs */
    @objc func loginToHomePage() {
        // Highlight view on tap
        UIView.animate(withDuration: 0.15, animations: {
            self.viewForLogin.alpha = 0.8
        }) { (success) in
            self.viewForLogin.alpha = 1
        }
        
        
        let urlString = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: urlString, success: {
            // On success: Persist data + Login to home page
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (error) in
            /*
            let rateLimitUrlString = "https://api.twitter.com/1.1/application/rate_limit_status.json"
            TwitterAPICaller.client?.getDictionaryRequest(url: rateLimitUrlString, parameters: ["resources": "help"], success: { (rateLimits: NSDictionary) in
                print(rateLimits)
            }, failure: { (error) in
                print(error)
            })
            */
            
            print(error)
            // On failure: Present an error alert
            let title = "Error"
            let message = "An error has occured. Unable to log-in."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
}

/* Disable stock highlight behavior for button */
extension UIButton {
    override open var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                super.isHighlighted = false
            }
        }
    }
}
