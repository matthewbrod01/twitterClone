//
//  ContainerViewController.swift
//  Twitter
//
//  Created by Matthew Rodriguez on 3/7/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var sideMenuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in containerVC")
        
        sideMenuButton.setBackgroundImage(UIImage(named: "profile-pic.png"), for: .normal)
        sideMenuButton.layer.borderWidth = 1
        sideMenuButton.layer.borderColor = UIColor.lightGray.cgColor
        //sideMenuButton.layer.backgroundColor = UIColor.blue.cgColor
        sideMenuButton.layer.masksToBounds = false
        sideMenuButton.layer.cornerRadius = sideMenuButton.frame.height / 2
        sideMenuButton.clipsToBounds = true
    }
    
    @IBAction func onTapMenu(_ sender: Any) {
        performSegue(withIdentifier: "SideMenuNavSegue", sender: UIButton.self)
    }
    
}
