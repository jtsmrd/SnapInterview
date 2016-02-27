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

class CreateInterviewVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CreateQuestionVCDelegate {

    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var businessProfile: BusinessProfile!
    var interviewQuestions: [InterviewQuestion] = []
    var businessProfileCKRecordName: String!
    var interviewTemplateCKRecordID: CKRecordID!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        if let errorMessage = validateTextFields() {
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            syncInterviewTemplateToCloud()
        }
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    
    private func saveInterviewTemplate() {
        var interviewTemplate: InterviewTemplate!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        coreDataStack.mainQueueContext.performBlockAndWait() {
            interviewTemplate = NSEntityDescription.insertNewObjectForEntityForName("InterviewTemplate", inManagedObjectContext: coreDataStack.mainQueueContext) as! InterviewTemplate
            interviewTemplate.jobTitle = self.titleTextField.text
            interviewTemplate.jobDescription = self.descriptionTextView.text
            interviewTemplate.businessProfile = self.businessProfile
            interviewTemplate.interviewQuestions = NSSet.init(array: self.interviewQuestions)
            interviewTemplate.cKRecordName = self.interviewTemplateCKRecordID.recordName
        }
        do {
            try coreDataStack.saveChanges()
            navigationController?.popViewControllerAnimated(true)
        }
        catch let error {
            print(error)
        }
    }
    
    // Save interview template to cloud
    private func syncInterviewTemplateToCloud() {
        let businessProfileRecordID = CKRecordID(recordName: businessProfileCKRecordName)
        let interviewTemplate = CKRecord(recordType: "InterviewTemplate")
        interviewTemplate.setValue(titleTextField.text, forKey: "jobTitle")
        interviewTemplate.setValue(descriptionTextView.text, forKey: "jobDescription")
        let businessProfileReference = CKReference(recordID: businessProfileRecordID, action: .DeleteSelf)
        interviewTemplate.setObject(businessProfileReference, forKey: "businessProfile")
        
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        publicDatabase.saveRecord(interviewTemplate, completionHandler: { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let record = record {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.interviewTemplateCKRecordID = record.recordID
                    self.saveInterviewTemplateQuestions()
                    self.saveInterviewTemplate()
                })
            }
        })
    }
    
    private func saveInterviewTemplateQuestions() {
        if interviewQuestions.count > 0 {
            for question in interviewQuestions {
                let questionRecord = CKRecord(recordType: "Question")
                questionRecord.setValue(question.question, forKey: "question")
                questionRecord.setValue(question.timeLimitInSeconds, forKey: "timeLimitInSeconds")
                let interviewTemplateReference = CKReference(recordID: interviewTemplateCKRecordID, action: .DeleteSelf)
                questionRecord.setObject(interviewTemplateReference, forKey: "interviewTemplate")
                
                let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
                publicDatabase.saveRecord(questionRecord, completionHandler: { (record, error) -> Void in
                    if let error = error {
                        print(error)
                    }
                })
            }
        }
    }
    
    private func validateTextFields() -> String? {
        var errorMessage: String?
        if titleTextField.text == "" {
            errorMessage = "The Title field is required."
        }
        else if descriptionTextView.text == "" {
            errorMessage = "The Description field is required."
        }
        return errorMessage
    }
    
    // MARK: - CreateQuestionVC Delegate Methods
    
    func controller(controller: CreateQuestionVC, AddedQuestion question: InterviewQuestion) {
        interviewQuestions.append(question)
        tableView.reloadData()
    }
    
    // MARK: TextField Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    // MARK: - Table View Datasource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interviewQuestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell", forIndexPath: indexPath)
        let item = interviewQuestions[indexPath.row]
        cell.textLabel?.text = item.question
        return cell
    }
    
    // MARK: - Navigation Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addQuestion" {
            let createQuestionVC = segue.destinationViewController as! CreateQuestionVC
            createQuestionVC.delegate = self
        }
    }
}
