//
//  BusinessSignupViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/12/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class BusinessSignupVC: UIViewController {

    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let myKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createAction(sender: UIButton) {
        
        if let errorMessage = validateTextFields() {
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            
            // Set the email and login status
            NSUserDefaults.standardUserDefaults().setValue(emailTextField.text, forKey: "email")
            NSUserDefaults.standardUserDefaults().setValue("business", forKey: "profileType")
            
            myKeychainWrapper.mySetObject(passwordTextField.text, forKey:kSecValueData)
            myKeychainWrapper.writeToKeychain()
            
            saveBusinessProfile()
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // Send to BusinessProfileStoryboard
            showBusinessProfile()
        }
    }
    
    // Save profile data to CoreData
    private func saveBusinessProfile() {
        
        var businessProfile: BusinessProfile!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        let businessName = businessNameTextField.text!
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let email = emailTextField.text!
        
        coreDataStack.mainQueueContext.performBlockAndWait() {
            businessProfile = NSEntityDescription.insertNewObjectForEntityForName("BusinessProfile", inManagedObjectContext: coreDataStack.mainQueueContext) as! BusinessProfile
            businessProfile.businessName = businessName
            businessProfile.firstName = firstName
            businessProfile.lastName = lastName
            businessProfile.email = email
        }
        
        do {
            try coreDataStack.saveChanges()
            syncBusinessProfileToCloud()
        }
        catch let error {
            print(error)
        }
    }
    
    // Save profile data to cloud
    private func syncBusinessProfileToCloud() {
        
        let businessProfileRecord = CKRecord(recordType: "BusinessProfile")
        businessProfileRecord.setValue(firstNameTextField.text, forKey: "firstName")
        businessProfileRecord.setValue(lastNameTextField.text, forKey: "lastName")
        businessProfileRecord.setValue(emailTextField.text, forKey: "email")
        businessProfileRecord.setValue(businessNameTextField.text, forKey: "businessName")
        
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        publicDatabase.saveRecord(businessProfileRecord, completionHandler: { (record, error) -> Void in
            if let error = error {
                print(error)
            }
        })
    }
    
    // Send the user to the Profile screen
    func showBusinessProfile() {
        
        let storyboard = UIStoryboard(name: "BusinessProfileStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("BusinessProfileTabBarController") as? UITabBarController
        presentViewController(viewController!, animated: true, completion: nil)
    }

    func validateTextFields() -> String? {
        
        var errorMessage: String?
        
        if businessNameTextField.text == "" {
            errorMessage = "The Business Name field is required."
        }
        else if firstNameTextField.text == "" {
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
