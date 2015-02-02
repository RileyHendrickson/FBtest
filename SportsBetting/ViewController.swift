//
//  ViewController.swift
//  SportsBetting
//
//  Created by Riley Hendrickson on 1/30/15.
//  Copyright (c) 2015 Riley Hendrickson. All rights reserved.
//

import UIKit
import CryptoSwift
import Foundation
//import CommonCrypto

class ViewController: UIViewController, FBLoginViewDelegate {
    
    @IBOutlet var fbLoginView : FBLoginView!
    @IBOutlet var profilePictureView : FBProfilePictureView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        var interfaceName = String()
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        {
            interfaceName = "iPad"
        } else if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone)
        {
            interfaceName = "iPhone"
        }
        
        var device = UIDevice.currentDevice()
        //println(device.name, device.systemName, device.systemVersion, device.model, device.localizedModel,device.identifierForVendor.UUIDString)
        //println(interfaceName)
        
        
        
        //var strTest = "data testing"
        let date = NSDate()
        let timestamp = date.timeIntervalSince1970
        //var strTest = "$2y$10$uID4XnCset1vkxN.1W0w.OH27Et8/aj.2wgIHPtJq0dEKb/73X0pa|\(timestamp)|\(device.identifierForVendor.UUIDString)"
        var strTest = "$2y$10$uID4XnCset1vkxN.1W0w.OH27Et8/aj.2wgIHPtJq0dEKb/73X0pa"
        var keyStr = "4sZHK5oYi4CVRAx7"
        var encryptedStr = "z7uYRApLbx7FrR4ZdSYq8n94w6dEUHkKtABWOyBXWmhJyoVLSI70TQCsGiXnVxjt8LNMsDQH/4N2aSVceiZCX//T3EaxalJyHr6j6b/C+oLQIOMUFQRP9Plocaprj+j8Ml8FbMgkOvSQkypc2fTaVJErohE0a1iEPQPfL+Rlxr/D1Hm3spPixy3/T1rsYmgDIWpYfm8zdLPgufXdOtgoYl7K29NXkQvrA+A5cYzt/ppHULToBXqr29nBQtjKhpxeSih2hDO+RCxcc33drimZd+SQE2Pk3iYCuKQIIw2xsa9/uXhrEZLVVFAW4XjEDr4EG0DSmCQbePE5uM58AUBfSDAAkpk8YK3GAXXSp22qx1DdAztCMVw82ad1hW7e9EhF5cxhyMdVczE1BeOireTnCgqsgDzkq0qJ5c9F4MVKLBFm9L7FHeIlGSctAdurUtqVp63VfpEDfAzng1oIEBFAeQKvIsjpDtlI/nUsVgvIsD4DOqg7htKFdsa8tHG8tduqkFWJizicRBQ5BmFWacxEcvUDAEDFATaQHAtFg0N+KTeKXI/Gg8svBNUUdlZRfR6QrPhlLrN0Ys91kjFWn5m6U0AzyBT2KeyZgGZNWcnGjgOqrFxetIMkvypIcUUJdu/HTEPjTz8ghH28/8PnErcptEPVmw3Fi+RGOnXYN/XzscDosrK/8k9ec4P6PgYnA7EIgbDbnhCoAE9XEb9OIzxpnR8+eNZ0TFA2e9JkEymJnGusyP8zlwxq6BimW4A6ctyCOJ14B7OkoOAGueDXaoCAeTj913g73f+Nz1zTIP1AdRzOadoOMebuEU4aRAA8tDowNTiYsm74pN/Zci1jo8acQva8gcGg1K53SmX4oOphIc9fsNuqJuxpV42bgmfqkq07IpZeT7IfTPlQpIDjBLRXXaW29jm/Kw6xy0+ecNM8nOIjYp1baVtIp+HRBpP4GV93tauPmbw8Vw8ccQrVYowusrDBAwDxmy1Eedu1PK2pw0acwn1nCCEWKPX5MVO1eAh17IojBT0D7YgHRzrHdrP5xv5fPUeyhSFniTNkYENogjRU6Mba7M2LElwDtQL9oCBcZBStX5v4k4YdpbyKMZuylg=="
        
        let keyData = keyStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let ivData:NSData = Cipher.randomIV(keyData)
        
        let encrypted = encrypt(strTest.dataUsingEncoding(NSUTF8StringEncoding)!, keyData: keyData)
        let decrypted = decrypt(encrypted, keyData: keyData)
        let base64String = encrypted.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        println(base64String)
        
        var encryptedStrData = NSData(base64EncodedString: encryptedStr, options: NSDataBase64DecodingOptions.allZeros)!
        let decryptedTryData = decrypt(encryptedStrData, keyData: keyData)
        let plaintext = NSString(CString: decryptedTryData, encoding: NSUTF8StringEncoding)!
        println(plaintext)
        
    }
    
    func decrypt(transferData:NSData, keyData:NSData) -> String {
        let ivData = transferData.subdataWithRange(NSRange(location: 0, length: AES.blockSizeBytes()))
        let encryptedData = transferData.subdataWithRange(NSRange(location: AES.blockSizeBytes(), length: transferData.length - AES.blockSizeBytes()))
        
        let aes = AES(key: keyData, iv: ivData, blockMode: .CBC) // CBC is default
        let decryptedData = Cipher.AES(key: keyData, iv: ivData, blockMode: .CBC).decrypt(encryptedData)
        let decryptedString = NSString(data: decryptedData!, encoding: NSUTF8StringEncoding)!
        return decryptedString
    }
    
    func encrypt(plaintextData:NSData, keyData:NSData) -> NSData {
        let ivData:NSData = Cipher.randomIV(keyData)
        let cipherdata = Cipher.AES(key: keyData, iv: ivData, blockMode: .CBC).encrypt(plaintextData)
        let transferData = NSMutableData(data: ivData)
        transferData.appendData(cipherdata!)
        return transferData
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        //println("User: \(user)")
        
        //user.keyEnumerator()
        
        
        
        /*
        // Get List Of Friends
        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultdict = result as NSDictionary
            self.profilePictureView.profileID = user.objectID
            self.profilePictureView.pictureCropping = FBProfilePictureCropping.Square
            self.profilePictureView.frame = CGRectMake(200, 200, 100, 100)
            self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2
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
        
        self.view.addSubview(profilePictureView) */

    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    // Get List Of Friends
    
    //Add video files below
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendRequest() {
        /* Configure session, choose between:
        * defaultSessionConfiguration
        * ephemeralSessionConfiguration
        * backgroundSessionConfigurationWithIdentifier:
        And set session-wide properties, such as: HTTPAdditionalHeaders,
        HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
        */
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        /* Create session, and optionally set a NSURLSessionDelegate. */
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
        Encrypt (GET http://sportsapi.app/encrypt)
        */
        
        var URL = NSURL(string: "http://sportsapi.app/encrypt")
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "GET"
        
        /* Start a new Task */
        let task = session.dataTaskWithRequest(request, completionHandler: { (data : NSData!, response : NSURLResponse!, error : NSError!) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as NSHTTPURLResponse).statusCode
                println("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                // Failure
                println("URL Session Task Failed: %@", error.localizedDescription);
            }
        })
        task.resume()
    }
    
}
    

