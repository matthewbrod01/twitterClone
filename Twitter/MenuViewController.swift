//
//  MenuViewController.swift
//  Twitter
//
//  Created by Matthew Rodriguez on 3/7/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfilePic()
    }
    
    func configureProfilePic() {
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func onTapSignOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        
        // Set view to login screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        let window = UIApplication.shared.keyWindow//?.rootViewController = loginViewController
        UIView.transition(with: window!, duration: 0.7, options: .transitionCrossDissolve, animations: {
            window!.rootViewController = loginViewController
        }, completion: { completed in
            print("Logged out")
            
            let title = "Signed out"
            let message = "Successfully Signed Out."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
}

/*
 /* Log out event handler */
 @IBAction func onTapLogout(_ sender: Any) {
 TwitterAPICaller.client?.logout()
 UserDefaults.standard.set(false, forKey: "userLoggedIn")
 self.dismiss(animated: true, completion: nil)
 }
 */
