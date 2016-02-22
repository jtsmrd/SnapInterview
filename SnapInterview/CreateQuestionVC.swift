//
//  CreateQuestionVC.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/21/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData

protocol CreateQuestionVCDelegate {
    
    func controller(controller: CreateQuestionVC, AddedQuestion question: InterviewQuestion)
}

class CreateQuestionVC: UIViewController, UITextFieldDelegate{

    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var timeLimitTextField: UITextField!
    var delegate: CreateQuestionVCDelegate?
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func cancelAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        var interviewQuestion: InterviewQuestion!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        coreDataStack.mainQueueContext.performBlockAndWait() {
            interviewQuestion = NSEntityDescription.insertNewObjectForEntityForName("InterviewQuestion", inManagedObjectContext: coreDataStack.mainQueueContext) as! InterviewQuestion
            interviewQuestion.question = self.questionTextView.text
            interviewQuestion.timeLimitInSeconds = Int(self.timeLimitTextField.text!)
        }
        delegate?.controller(self, AddedQuestion: interviewQuestion)
        navigationController?.popViewControllerAnimated(true)
    }
    
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
}
