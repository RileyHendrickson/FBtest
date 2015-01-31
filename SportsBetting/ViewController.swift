//
//  ViewController.swift
//  SportsBetting
//
//  Created by Riley Hendrickson on 1/30/15.
//  Copyright (c) 2015 Riley Hendrickson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBLoginViewDelegate {
    
    @IBOutlet var fbLoginView : FBLoginView!
    @IBOutlet var profilePictureView : FBProfilePictureView!
    
    //@IBOutlet var profilePictureView : FBProfilePictureView! - This is the IBOutlet for the picture view
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends", "user_photos"]
        
        
        
        //Added video file for launch screen background
        var filePath = NSBundle.mainBundle().pathForResource("tumblr", ofType: "gif")
        var gif = NSData(contentsOfFile: filePath!)
        
        var webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.loadData(gif, MIMEType: "image/gif", textEncodingName: nil, baseURL: nil)
        webViewBG.userInteractionEnabled = false;
        self.view.addSubview(webViewBG)
        
        var filter = UIView()
        filter.frame = self.view.frame
        filter.backgroundColor = UIColor.blackColor()
        filter.alpha = 0.05
        self.view.addSubview(filter)
        
        var welcomeLabel = UILabel(frame: CGRectMake(0, 100, self.view.bounds.size.width, 100))
        welcomeLabel.text = "WELCOME"
        welcomeLabel.textColor = UIColor.whiteColor()
        welcomeLabel.font = UIFont.systemFontOfSize(50)
        welcomeLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(welcomeLabel)
        
        //var loginBtn = UIButton(frame: CGRectMake(40, 360, 240, 40))
        //loginBtn.layer.borderColor = UIColor.whiteColor().CGColor
        //loginBtn.layer.borderWidth = 2
        //loginBtn.titleLabel!.font = UIFont.systemFontOfSize(24)
        //loginBtn.tintColor = UIColor.whiteColor()
        //loginBtn.setTitle("Login", forState: UIControlState.Normal)
        //self.view.addSubview(loginBtn)
        
        //var signUpBtn = UIButton(frame: CGRectMake(40, 420, 240, 40))
        //signUpBtn.layer.borderColor = UIColor.whiteColor().CGColor
        //signUpBtn.layer.borderWidth = 2
        //signUpBtn.titleLabel!.font = UIFont.systemFontOfSize(24)
        //signUpBtn.tintColor = UIColor.whiteColor()
        //signUpBtn.setTitle("Sign Up", forState: UIControlState.Normal)  -   [Need to replace with the FB login button]
        //self.view.addSubview(signUpBtn)
        
        
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        
        
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
        
        var profileImageView = FBProfilePictureView()
        
        // Get List Of Friends From FB
        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultdict = result as NSDictionary
            
            
            //self.profilePictureView.profileID = user.objectID                                           Grabbing the photo from the FB profile
            //self.profilePictureView.pictureCropping = FBProfilePictureCropping.Square                   Setting the photo to a square
            //self.profilePictureView.frame = CGRectMake(200, 200, 100, 100)                              Setting the Photo frame
            //self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2   Setting the photo size
            
            
            
            
            println("Result Dict: \(resultdict)")
            var data : NSArray = resultdict.objectForKey("data") as NSArray
            
            for i in 0..<data.count {
                let valueDict : NSDictionary = data[i] as NSDictionary
                let id = valueDict.objectForKey("id") as String
                println("the id value is \(id)")
            }
            
            var friends = resultdict.objectForKey("data") as NSArray
            println("Found \(friends.count) friends")
            
           
            
        }
        
            //Added a view for
            //self.view.addSubview(profilePictureView)
        
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
}
