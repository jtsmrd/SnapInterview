//
//  SignupViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/2/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class IndividualSignupViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let myKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Save profile daat to cloud
    
    @IBAction func createAction() {
        
        if let errorMessage = validateTextFields() {
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            
            // Set the email and login status
            NSUserDefaults.standardUserDefaults().setValue(emailTextField.text, forKey: "email")
            NSUserDefaults.standardUserDefaults().setValue("individual", forKey: "profileType")
            
            myKeychainWrapper.mySetObject(passwordTextField.text, forKey:kSecValueData)
            myKeychainWrapper.writeToKeychain()
            
            let individualProfileRecord = CKRecord(recordType: "IndividualProfile")
            individualProfileRecord.setValue(firstNameTextField.text, forKey: "firstName")
            individualProfileRecord.setValue(lastNameTextField.text, forKey: "lastName")
            individualProfileRecord.setValue(emailTextField.text, forKey: "email")
            
            let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
            publicDatabase.saveRecord(individualProfileRecord, completionHandler: { (record, error) -> Void in
                if let error = error {
                    print(error)
                }
            })
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func validateTextFields() -> String? {
        
        var errorMessage: String?
        
        if firstNameTextField.text == "" {
            errorMessage = "The First Name field is required."
        }
        else if lastNameTextField.text == "" {
            errorMessage = "The Last Name field is required."
        }
        else if emailTextField.text == "" {
            errorMessage = "The Email field is required."
        }
        else if passwordTextField.text == "" {
            errorMessage = "The Password field is required."
        }
        
        return errorMessage
    }
}