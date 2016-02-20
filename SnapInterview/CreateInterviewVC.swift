//
//  CreateInterviewVC.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/18/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class CreateInterviewVC: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var businessProfile: BusinessProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        
        if let errorMessage = validateTextFields() {
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            saveInterview()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func saveInterview() {
        
        var interview: Interview!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        let title = titleTextField.text
        let description = descriptionTextView.text
        
        coreDataStack.mainQueueContext.performBlockAndWait() {
            interview = NSEntityDescription.insertNewObjectForEntityForName("Interview", inManagedObjectContext: coreDataStack.mainQueueContext) as! Interview
            interview.title = title
            interview.desc = description
            interview.businessProfile = self.businessProfile
        }
        
        do {
            try coreDataStack.saveChanges()
        }
        catch let error {
            print(error)
        }
    }
    
    func validateTextFields() -> String? {
        
        var errorMessage: String?
        
        if titleTextField.text == "" {
            errorMessage = "The Title field is required."
        }
        else if descriptionTextView.text == "" {
            errorMessage = "The Description field is required."
        }
        
        return errorMessage
    }
}
