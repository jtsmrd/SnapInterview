//
//  EditIndividualProfileViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/16/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData

class EditIndividualProfileViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var individualProfile: IndividualProfile!
    var profileUpdated: Bool = false
    let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.text = individualProfile.firstName
        lastNameTextField.text = individualProfile.lastName
    }
    
    @IBAction func saveAction(sender: UIButton) {
        profileUpdated = true
        
        saveIndividualProfile()
    }
    
    // Save profile data to CoreData
    private func saveIndividualProfile() {
        
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let title = titleTextField.text!
        
        var individualProfile: IndividualProfile!
        let coreDataStack = CoreDataStack(modelName: "SnapInterviewEntities")
        let fetchRequest = NSFetchRequest(entityName: "IndividualProfile")
        fetchRequest.predicate = NSPredicate(format: "email = %@", userEmail!)
        
        coreDataStack.mainQueueContext.performBlockAndWait() {
            do {
                let records = try coreDataStack.mainQueueContext.executeFetchRequest(fetchRequest) as? [IndividualProfile]
                
                individualProfile = records![0]
            }
            catch let error {
                print(error)
            }
        }
        
        individualProfile.firstName = firstName
        individualProfile.lastName = lastName
        individualProfile.jobTitle = title
        
        do {
            try coreDataStack.saveChanges()
            //syncIndividualProfileToCloud()
        }
        catch let error {
            print(error)
        }
    }
}
