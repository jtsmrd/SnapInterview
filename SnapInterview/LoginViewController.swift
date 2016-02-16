//
//  LoginViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/1/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!      
    @IBOutlet weak var passwordTextField: UITextField!
    
    let myKeychainWrapper = KeychainWrapper()
    
    @IBAction func loginAction() {
        
        // Set the login status and dismiss the login screen
        if checkLogin(emailTextField.text!, password: passwordTextField.text!) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let profileType = NSUserDefaults.standardUserDefaults().valueForKey("profileType") as? String
            
            if profileType == "individual" {
                
                // Show IndividualProfile StoryBoard
                showIndividualProfile()
            }            
        }
        else {
            alert("Login Failed", message: "Incorrect email/password combination")
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLoggedIn() {
            showIndividualProfile()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // If there's a login email, populate the email text field
        if let storedEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String {
            emailTextField.text = storedEmail as String
        }
        
        passwordTextField.text = ""
    }
    
    func showIndividualProfile() {
        
        let storyboard = UIStoryboard(name: "IndividualProfileStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("IndividualProfileTabBarController") as? UITabBarController
        presentViewController(viewController!, animated: true, completion: nil)
    }
    
    func isLoggedIn() -> Bool {
        
        // Check for username and isLoggedIn in NSUserDefaults
        return NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
    }
    
    // Check the email from NSUserDefaults and the password from the keychain
    func checkLogin(email: String, password: String ) -> Bool {
        if password == myKeychainWrapper.myObjectForKey("v_Data") as? String &&
            email == NSUserDefaults.standardUserDefaults().valueForKey("email") as? String {
                return true
        }
        else {
            return false
        }
    }
    
    func alert(title: String, message: String) {
        let alertView = UIAlertController(title: title,
            message: message, preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}