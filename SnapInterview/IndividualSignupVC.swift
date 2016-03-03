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

class IndividualSignupVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables and Constants
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let myKeychainWrapper = KeychainWrapper()
    var individualProfileCKRecordName: String!
    
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
    
    @IBAction func createAction() {
        createProfile()
    }
    
    // Dismiss the keyboard when the backgroud is tapped
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
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
    
    // Create Firebase account with email/password for authentication
    private func createFirebaseUserAccount() {
        
    }
    
    // Validate and create an IndividualProfile
    private func createProfile() {
        if let errorMessage = validateTextFields() {
            showErrorAlert(errorMessage)
        }
        else {
            // Save password to Keychain
            myKeychainWrapper.mySetObject(passwordTextField.text, forKey:kSecValueData)
            myKeychainWrapper.writeToKeychain()
            syncIndividualProfileToCloud()
            setUserDefaults()
        }
    }
    
    // Save profile data using CoreData. If successful, save to cloud
    private func saveIndividualProfile() {
        var individualProfile: IndividualProfile!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        
        // Create and insert new IndividualProfile
        coreDataStack.mainQueueContext.performBlockAndWait() {
            individualProfile = NSEntityDescription.insertNewObjectForEntityForName("IndividualProfile", inManagedObjectContext: coreDataStack.mainQueueContext) as! IndividualProfile
            individualProfile.firstName = self.firstNameTextField.text!
            individualProfile.lastName = self.lastNameTextField.text!
            individualProfile.email = self.emailTextField.text!
            individualProfile.cKRecordName = self.individualProfileCKRecordName
        }
        
        do {
            try coreDataStack.saveChanges()
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
    private func syncIndividualProfileToCloud() {
        let individualProfileRecord = CKRecord(recordType: "IndividualProfile")
        individualProfileRecord.setValue(firstNameTextField.text, forKey: "firstName")
        individualProfileRecord.setValue(lastNameTextField.text, forKey: "lastName")
        individualProfileRecord.setValue(emailTextField.text, forKey: "email")
        
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        publicDatabase.saveRecord(individualProfileRecord, completionHandler: { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let record = record {
                self.individualProfileCKRecordName = String(record.recordID.recordName)
                self.saveIndividualProfile()
            }
        })
    }
    
    // Make sure textfields contain text
    private func validateTextFields() -> String? {
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
        NSUserDefaults.standardUserDefaults().setValue("individual", forKey: "profileType")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}