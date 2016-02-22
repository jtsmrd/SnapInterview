//
//  LoginViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/1/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables and Constants
    
    @IBOutlet weak var emailTextField: UITextField!      
    @IBOutlet weak var passwordTextField: UITextField!
    
    let myKeychainWrapper = KeychainWrapper()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isLoggedIn() {
            showProfile()
        }
        
        // If there's a login email, populate the email text field
        if let storedEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String {
            emailTextField.text = storedEmail as String
        }
        
        passwordTextField.text = ""
    }
    
    // Dismiss the keyboard when the view disappears
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(true)
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func loginAction() {
        login()
    }
    
    // Dismiss the keyboard when the backgroud is tapped
    @IBAction func backgroudTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: TextField Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    // MARK: Private Methods
    
    // Set the login status and show the profile
    private func login() {
        if checkLogin(emailTextField.text!, password: passwordTextField.text!) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            showProfile()
        }
        else {
            alert("Login Failed", message: "Incorrect email/password combination")
        }
    }
    
    // Show the correct profile
    private func showProfile() {
        let profileType = NSUserDefaults.standardUserDefaults().valueForKey("profileType") as? String
        
        if profileType == "individual" {
            showIndividualProfile()
        }
        else if profileType == "business" {
            showBusinessProfile()
        }
    }
    
    // Show IndividualProfile Storyboard
    private func showIndividualProfile() {
        let storyboard = UIStoryboard(name: "IndividualProfileStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("IndividualProfileTabBarController") as? UITabBarController
        presentViewController(viewController!, animated: false, completion: nil)
    }
    
    // Show BusinessProfile Storyboard
    private func showBusinessProfile() {
        let storyboard = UIStoryboard(name: "BusinessProfileStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("BusinessProfileTabBarController") as? UITabBarController
        presentViewController(viewController!, animated: false, completion: nil)
    }
    
    // Check the isLoggedIn status in NSUserDefaults
    private func isLoggedIn() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
    }
    
    // Check the email from NSUserDefaults and the password from the keychain
    private func checkLogin(email: String, password: String ) -> Bool {
        if password == myKeychainWrapper.myObjectForKey("v_Data") as? String &&
            email == NSUserDefaults.standardUserDefaults().valueForKey("email") as? String {
                return true
        }
        else {
            return false
        }
    }
    
    // Show alert controller
    private func alert(title: String, message: String) {
        let alertView = UIAlertController(title: title,
            message: message, preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}