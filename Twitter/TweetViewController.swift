//
//  TweetViewController.swift
//  Twitter
//
//  Created by Matthew Rodriguez on 3/6/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // Mimic placeholder text
        tweetTextView.delegate = self
        tweetTextView.text = "What's happening?"
        tweetTextView.textColor = UIColor.lightGray
        */
        
        // Show keyboard
        tweetTextView.becomeFirstResponder()
    }
    
    /* Cancel tweet */
    @IBAction func onTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /* Post a tweet */
    @IBAction func onTapTweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print(error.localizedDescription)
                
                // On failure: Present an error alert
                let title = "Error"
                let message = "An error has occured. Unable to post tweet."
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        } else { //if empty tweet
            // On failure: Present an error alert
            let title = "Error"
            let message = "Unable to post empty tweet."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
    
    /* Remove placeholder text when user types something */
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tweetTextView.textColor == UIColor.lightGray {
            tweetTextView.text = ""
            tweetTextView.textColor = UIColor.black
        }
    }
    
    /* Set back placeholder text when user deletes characters */
    func textViewDidEndEditing(_ textView: UITextView) {
        if tweetTextView.text == "" {
            tweetTextView.text = "What's happening?"
            tweetTextView.textColor = UIColor.lightGray
        }
    }
    */
}
