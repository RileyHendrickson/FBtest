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
        
        //var device = UIDevice.currentDevice()
        //println(device.name, device.systemName, device.systemVersion, device.model, device.localizedModel,device.identifierForVendor.UUIDString)
        //println(interfaceName)
        
        var strTest = "data testing"
        var keyStr = "4sZHK5oYi4CVRAx7"
        var encryptedStr = "o+U3+wESWmhD01W5Oz48vy+bK6vpdk7Z854CAGeYtJEGD+TC+Ke2djUYa7adDqgdz5Db/eNvEgfL1PiUazV7vnJvB7vmCsu6I2fKCypkClczKTERc0I/Fa6+Z/ikEFOoXYbw/KnGo1qnkd9PZykMIg6bhlBLv6Vv5ozLHcOeZIRZZhUPM37Mpitjg884LmuXXR16YtYH5IDLzzo6EZox228hIXDFgeIReniJTaxm0Ek="
        
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
    
}