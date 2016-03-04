//
//  LoginViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/1/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables and Constants
    
    @IBOutlet weak var emailTextField: UITextField!      
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //******** HANDLE THIS
        if isLoggedIn() {
            //showProfile()
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
        let firebase = Firebase(url: "https://snapinterview.firebaseio.com")
        firebase.authUser(emailTextField.text!, password: passwordTextField.text!) {
            error, authData in
            if error != nil {
                self.alert("Login Failed", message: "Invalid username/password combination.")
            }
            else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.showProfile(authData.uid)
            }
        }
    }
    
    // Show the correct profile
    private func showProfile(profileUID: String) {
        var profileType: String!
        let firebase = Firebase(url: "https://snapinterview.firebaseio.com/users/\(profileUID)")
        firebase.observeEventType(.Value) { (snapshot: FDataSnapshot!) -> Void in
            if let record = snapshot.value {
                profileType = record["profileType"] as! String
                
                if profileType == "Individual" {
                    self.showIndividualProfile(profileUID)
                }
                else if profileType == "Business" {
                    self.showBusinessProfile(profileUID)
                }
            }
        }
    }
    
    // Show IndividualProfile Storyboard
    private func showIndividualProfile(profileUID: String) {
        let storyboard = UIStoryboard(name: "IndividualProfileStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("IndividualProfileTabBarController") as? UITabBarController
        let individualProfileVC = viewController?.viewControllers![0] as! IndividualProfileVC
        individualProfileVC.profileFirebaseUID = profileUID
        presentViewController(viewController!, animated: false, completion: nil)
    }
    
    // Show BusinessProfile Storyboard
    private func showBusinessProfile(profileUID: String) {
        let storyboard = UIStoryboard(name: "BusinessProfileStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("BusinessProfileTabBarController") as? UITabBarController
        let businessProfileVC = viewController?.viewControllers![0] as! BusinessProfileVC
        businessProfileVC.profileFirebaseUID = profileUID
        presentViewController(viewController!, animated: false, completion: nil)
    }
    
    // Check the isLoggedIn status in NSUserDefaults
    private func isLoggedIn() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
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