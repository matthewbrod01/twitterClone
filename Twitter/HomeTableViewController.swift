//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Matthew Rodriguez on 2/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import MBProgressHUD

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int = 0
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTweets()
        
        // Target: This screen
        // Action: Call function fetchTweets()
        // for: .valueChanged (occurs when we perform touch dragging)
        myRefreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        // Dynamic cell height resizing
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    
    /* Always called when view appears. viewDidLoad is only called once*/
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchTweets()
    }
    /* Pull to refresh event handler */
    @objc func didPullToRefresh() {
        self.showHUD(progressLabel: "Refreshing Tweets")
        fetchTweets()
    }
    
    /* Initial setup of home page */
    func fetchTweets() {
        numberOfTweets = 10 // When we pull to refresh, reset tweets to 10
        let urlString = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]

        TwitterAPICaller.client?.getDictionariesRequest(url: urlString, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            /*
            self.myRefreshControl.endRefreshing()
            DispatchQueue.main.async {
                self.dismissHUD(isAnimated: true)
            }
            */
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.myRefreshControl.endRefreshing()
                self.dismissHUD(isAnimated: true)
            })
            
        }, failure: { (error) in
            print(error.localizedDescription)
            // On failure: Present an error alert
            let title = "Error"
            let message = "An error has occured. Could not retrieve tweets."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    /* For infinite scroll */
    func fetchMoreTweets() {
        numberOfTweets += 10
        let urlString = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: urlString, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
    
        }, failure: { (Error) in
            // On failure: Present an error alert
            let title = "Error"
            let message = "An error has occured. Could not retrieve tweets."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    /* Log out event handler */
    @IBAction func onTapLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    /* Infinite scroll. When user is at bottom of tableView page, fetch more tweets */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            fetchMoreTweets()
        }
    }
    
    /* number of sections in tableView */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /* numbers of rows in sections */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    /* cell for each row */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        let userHandle = user["screen_name"] as? String
        cell.userHandleLabel.text = "@\(userHandle!)"

        let timestampOriginal = tweetArray[indexPath.row]["created_at"] as? String
        let timestampString = parseTimestampString(timestamp: timestampOriginal!)
        cell.timestampLabel.text = "•\(timestampString)"
        
        // Set image in Xcode without 3rd party library
        let urlString = user["profile_image_url_https"] as? String
        let imageUrl = URL(string: urlString!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        return cell
    }
    
    func parseTimestampString(timestamp: String) -> String {
        let formatter = DateFormatter()
        
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        
        // Convert String to Date
        let date = formatter.date(from: timestamp)
        
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        // Convert Date to String
        return formatter.string(from: date!)
    }
    
    /* Remove cell gray selection highlight effect on tap release */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIViewController {
    func showHUD(progressLabel: String) {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
    }
    
    func dismissHUD(isAnimated: Bool) {
        MBProgressHUD.hide(for: self.view, animated: isAnimated)
    }
}
