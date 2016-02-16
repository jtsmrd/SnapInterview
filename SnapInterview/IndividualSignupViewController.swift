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
        })
    }
    
    // Save profile data to CoreData
    private func saveIndividualProfile() {
        
        var individualProfile: IndividualProfile!
        let coreDataStack = CoreDataStack(modelName: "SnapInterviewEntities")
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let email = emailTextField.text!
        
        coreDataStack.privateQueueContext.performBlockAndWait() {
            individualProfile = NSEntityDescription.insertNewObjectForEntityForName("IndividualProfile", inManagedObjectContext: coreDataStack.privateQueueContext) as! IndividualProfile
            individualProfile.firstName = firstName
            individualProfile.lastName = lastName
            individualProfile.email = email
        }
        
        do {
            try coreDataStack.saveChanges()
            //syncIndividualProfileToCloud()
        }
        catch let error {
            print(error)
        }
    }
    
    // Send the user to the Profile screen
    func showIndividualProfile() {
        
        let storyboard = UIStoryboard(name: "IndividualProfileStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("IndividualProfileTabBarController") as? UITabBarController
        presentViewController(viewController!, animated: true, completion: nil)
    }
    
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
            
            saveIndividualProfile()
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // Send to IndividualProfileStoryboard
            showIndividualProfile()
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