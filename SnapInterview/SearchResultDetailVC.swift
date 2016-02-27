//
//  SearchResultDetailVC.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/23/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class SearchResultDetailVC: UIViewController, SelectInterviewTVCDelegate {

    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedInterviewLabel: UILabel!    
    var selectedInterviewTemplate: InterviewTemplate!
    var individualProfile: CKRecord!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstName = individualProfile.objectForKey("firstName") as? String {
            firstNameLabel.text = firstName
        }
        if let lastName = individualProfile.objectForKey("lastName") as? String {
            lastNameLabel.text = lastName
        }
        if let title = individualProfile.objectForKey("jobTitle") as? String {
            titleLabel.text = title
        }
    }
    
    // MARK: - Actions
    
    @IBAction func confirmInterviewAction(sender: UIButton) {
        confirmInterview()
    }
    
    // MARK: - Private Methods
    
    private func confirmInterview() {
        //saveInterviewToIndividualProfile()
    }
    
    private func saveToPendingInterviews() {
        
    }
    
    // Update this for new Interview object
    private func saveInterviewToIndividualProfile() {
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        let interviewReference = CKReference(recordID: CKRecordID.init(recordName: selectedInterviewTemplate.cKRecordName!), action: .None)
        var referenceList: [CKReference] = []
        
        if individualProfile.objectForKey("interviews") != nil {
            referenceList = individualProfile.objectForKey("interviews") as! [CKReference]
            referenceList.append(interviewReference)
        }
        else {
            referenceList.append(interviewReference)            
        }
        individualProfile.setObject(referenceList, forKey: "interviews")
        
        publicDatabase.saveRecord(individualProfile) { (record, error) -> Void in
            if let error = error {
                print(error)
            }
        }
    }
    
    // MARK: - CreateQuestionVC Delegate Methods
    
    func controller(controller: SelectInterviewTVC, SelectedInterviewTemplate interviewTemplate: InterviewTemplate) {
        selectedInterviewTemplate = interviewTemplate
        selectedInterviewLabel.text = selectedInterviewTemplate.jobTitle
    }
    
    // MARK: - Navigation Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectInterview" {
            let selectInterviewTVC = segue.destinationViewController as! SelectInterviewTVC
            selectInterviewTVC.delegate = self
        }
    }
    
    
    // MARK: - Delegate Methods
    // MARK: - Datasource Methods
}
