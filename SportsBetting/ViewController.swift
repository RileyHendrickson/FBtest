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
        
        var strTest = String("data")
        var keyStr = String("abcdefghijklmnop")
        //var byteArray = [Byte]()
        //byteArray = [UInt8](keyStr)
        
        //if let hash = strTest.sha256() {
        //    println(hash)
        //}
        
        // 1. Add padding (Optional)
        let plaintextData = PKCS7(data: strTest.dataUsingEncoding(NSUTF8StringEncoding)!).addPadding(AES.blockSizeBytes())
        
        // 2. Encrypt with key and random IV
        //let keyData = NSData.withBytes([0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
        let keyData = NSData.withBytes([UInt8](keyStr.utf8))
        //println([UInt8](keyStr.utf8))
        let ivData:NSData = Cipher.randomIV(keyData)
        
        let encryptedData = Cipher.AES(key: keyData, iv: ivData, blockMode: .CBC).encrypt(plaintextData)
        if let actualData = encryptedData {
            
        
        
        // or
        let aes = AES(key: keyData, iv: ivData, blockMode: .CBC) // CBC is default
        //let encryptedData = aes?.encrypt(plaintextData, addPadding: true) // With padding enabled
        
        // 3. decrypt with key and IV
        let decryptedData = Cipher.AES(key: keyData, iv: ivData, blockMode: .CBC).decrypt(encryptedData!)
        
        let plainttextData = PKCS7(data: decryptedData!).removePadding()
        var error: NSError?
        let encryptString = NSString(data: encryptedData!, encoding: NSUTF8StringEncoding)
        let resstr = NSString(data: plainttextData, encoding: NSUTF8StringEncoding)
        let encryptKey = NSString(data: keyData, encoding: NSUTF8StringEncoding)
        //println(encryptedData, encryptString, resstr, encryptKey)
        //println(encryptedData?.hexString)
        
            var bData = encryptedData?.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.allZeros)
            //var b64Data = NSData(base64EncodedData: encryptedData!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        //println(NSString(data: bData!, encoding: NSUTF8StringEncoding)
            let base64String = actualData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
            println(base64String)

        //let base64Encoded = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.fromRaw(0)!)

        //println(encryptString)
        //println(actualData.description, actualData.hexString, actualData)
        
        }
        
        
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        
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