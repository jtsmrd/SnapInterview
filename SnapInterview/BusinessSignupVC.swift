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
import Firebase

class BusinessSignupVC: UIViewController, UITextFieldDelegate {

    // MARK: - Variables and Constants
    
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var businessProfileCKRecordName: String!
    var businessProfileFirebaseUID: String!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Dismiss the keyboard when the view disappears
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func createAction(sender: UIButton) {
        createProfile()
    }
    
    // Dismiss the keyboard when the backgroud is tapped
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - TextField Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    // MARK: - Private Methods
    
    // Create Firebase account with email/password for authentication
    private func createFirebaseUserAccount() {
        let firebase = Firebase(url:"https://snapinterview.firebaseio.com")
        
        firebase.createUser(emailTextField.text, password: passwordTextField.text,
            withValueCompletionBlock: { error, result in
                
                if error != nil {
                    print(error)
                } else {
                    self.businessProfileFirebaseUID = result["uid"] as? String
                    let newUserProfileType = [
                        "profileType" : "Business"
                    ]
                    firebase.childByAppendingPath("users").childByAppendingPath(self.businessProfileFirebaseUID).setValue(newUserProfileType)
                    self.syncBusinessProfileToCloud()
                }
        })
    }
    
    // Validate and create a BusinessProfile
    private func createProfile() {
        if let errorMessage = validateTextFields() {
            showErrorAlert(errorMessage)
        }
        else {
            createFirebaseUserAccount()
        }
    }
    
    // Save profile data using CoreData. If successful, save to cloud
    private func saveBusinessProfile() {
        var businessProfile: BusinessProfile!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        
        // Create and insert new BusinessProfile
        coreDataStack.mainQueueContext.performBlockAndWait() {
            businessProfile = NSEntityDescription.insertNewObjectForEntityForName("BusinessProfile", inManagedObjectContext: coreDataStack.mainQueueContext) as! BusinessProfile
            businessProfile.businessName = self.businessNameTextField.text!
            businessProfile.firstName = self.firstNameTextField.text!
            businessProfile.lastName = self.lastNameTextField.text!
            businessProfile.email = self.emailTextField.text!
            businessProfile.businessProfileCKRecordName = self.businessProfileCKRecordName
            businessProfile.businessProfileFirebaseUID = self.businessProfileFirebaseUID
        }
        
        do {
            try coreDataStack.saveChanges()
            setUserDefaults()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.navigationController?.popToRootViewControllerAnimated(false)
            })
        }
        catch let error {
            print(error)
            showErrorAlert("\(error)")
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
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let error = error {
                    print(error)
                }
                else if let record = record {
                    self.businessProfileCKRecordName = String(record.recordID.recordName)
                    self.saveBusinessProfile()
                }
            })
        })
    }
    
    // Make sure textfields contain text
    private func validateTextFields() -> String? {
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
    
    // Show alert controller with error message
    private func showErrorAlert(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Set the user email, profile type, and logged in status in user defaults
    private func setUserDefaults() {
        NSUserDefaults.standardUserDefaults().setValue(emailTextField.text, forKey: "email")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
