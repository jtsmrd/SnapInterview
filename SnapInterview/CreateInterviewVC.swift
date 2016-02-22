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

class CreateInterviewVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateQuestionVCDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!    
    
    var businessProfile: BusinessProfile!
    var interviewStore = InterviewStore()
    var interviewQuestions: [InterviewQuestion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
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
            interview.questions = NSSet.init(array: self.interviewQuestions)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return interviewQuestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell", forIndexPath: indexPath)
        
        let item = interviewQuestions[indexPath.row]
        cell.textLabel?.text = item.question
        
        return cell
    }
    
    func controller(controller: CreateQuestionVC, AddedQuestion question: InterviewQuestion) {
        interviewQuestions.append(question)
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addQuestion" {
            let createQuestionVC = segue.destinationViewController as! CreateQuestionVC
            createQuestionVC.delegate = self
        }
    }
}
