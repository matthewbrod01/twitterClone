//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Matthew Rodriguez on 2/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTweets()
        
        // Target: This screen
        // Action: Call function fetchTweets()
        // for: .valueChanged (occurs when we perform touch dragging)
        myRefreshControl.addTarget(self, action: #selector(fetchTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func fetchTweets() {
        let urlString = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 20]

        TwitterAPICaller.client?.getDictionariesRequest(url: urlString, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            // On failure: Present an error alert
            let title = "Error"
            let message = "An error has occured. Could not retrieve tweets."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    @IBAction func onTapLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        // Set image in Xcode without 3rd party library
        let urlString = user["profile_image_url_https"] as? String
        let imageUrl = URL(string: urlString!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
}
