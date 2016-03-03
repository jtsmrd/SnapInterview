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
    var individualProfileCKRecord: CKRecord!
    var businessProfile: BusinessProfile!
    var interviewCKRecordName: String!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarViewControllers = self.tabBarController?.viewControllers
        let businessProfileVC = tabBarViewControllers![0] as! BusinessProfileVC
        businessProfile = businessProfileVC.businessProfile
        
        if let firstName = individualProfileCKRecord.objectForKey("firstName") as? String {
            firstNameLabel.text = firstName
        }
        if let lastName = individualProfileCKRecord.objectForKey("lastName") as? String {
            lastNameLabel.text = lastName
        }
        if let title = individualProfileCKRecord.objectForKey("jobTitle") as? String {
            titleLabel.text = title
        }
    }
    
    // MARK: - Actions
    
    @IBAction func confirmInterviewAction(sender: UIButton) {
        confirmInterview()
    }
    
    // MARK: - Private Methods
    
    private func confirmInterview() {
        saveInterviewToIndividualProfile()
    }
    
    private func saveToActiveInterviews() {
        // Create new Interview, set BusinessProfile, IndividualProfile, InterviewTemplate, and cKRecordName
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        var interview: Interview!
        coreDataStack.mainQueueContext.performBlockAndWait() { () -> Void in
            interview = NSEntityDescription.insertNewObjectForEntityForName("Interview", inManagedObjectContext: coreDataStack.mainQueueContext) as! Interview
            interview.businessProfile = self.businessProfile
            interview.interviewTemplate = self.selectedInterviewTemplate
            interview.cKRecordName = self.interviewCKRecordName
        }
        var allInterviews = businessProfile.interviews?.allObjects as! [Interview]
        allInterviews.append(interview)
        businessProfile.interviews = NSSet.init(array: allInterviews)
        do {
            try coreDataStack.saveChanges()
        }
        catch let error {
            print(error)
        }
    }
    
    func convertDictionaryToString(dictionary: [String:AnyObject]) -> String {
        var dictionaryString: String!
        do {
            let theJSONData = try NSJSONSerialization.dataWithJSONObject(
                dictionary, options: NSJSONWritingOptions(rawValue: 0))
            
            dictionaryString = NSString(data: theJSONData,
                encoding: NSASCIIStringEncoding) as! String
        }
        catch {
            print("error")
        }
        return dictionaryString
    }
    
    private func createInterviewData() -> String {
        var interviewDictionary = [String: AnyObject]()
        var questionsDictionary = [String: [String: AnyObject]]()
        let interviewQuestions = selectedInterviewTemplate.interviewQuestions?.allObjects as! [InterviewQuestion]
        interviewDictionary["InterviewTitle"] = selectedInterviewTemplate.jobTitle
        interviewDictionary["InterviewDescription"] = selectedInterviewTemplate.jobDescription
        
        for var i = 0; i < interviewQuestions.count; i++ {
            questionsDictionary["\(i)"] = [String: AnyObject]()
            questionsDictionary["\(i)"]!["Question"] = interviewQuestions[i].question
            questionsDictionary["\(i)"]!["TimeLimit"] = interviewQuestions[i].timeLimitInSeconds
        }
        
        interviewDictionary["Questions"] = questionsDictionary
        print(interviewDictionary)
        let dictionaryString = convertDictionaryToString(interviewDictionary)
        
        return dictionaryString
    }
    
    private func saveInterviewToIndividualProfile() {
        let interviewDetailsData = createInterviewData()
        let businessProfileReference = CKReference(recordID: CKRecordID.init(recordName: (selectedInterviewTemplate.businessProfile?.cKRecordName)!), action: .None)
        let individualProfileReference = CKReference(record: individualProfileCKRecord, action: .None)
        let interview = CKRecord(recordType: "Interview")
        interview.setObject(businessProfileReference, forKey: "businessProfile")
        interview.setObject(individualProfileReference, forKey: "individualProfile")
        interview.setObject(interviewDetailsData, forKey: "interviewDetailsData")
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        var interviewReferenceList: [CKReference] = []
        
        publicDatabase.saveRecord(interview) { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let interviewRecord = record {
                
                self.interviewCKRecordName = interviewRecord.recordID.recordName
                
                if self.individualProfileCKRecord.objectForKey("interviews") != nil {
                    interviewReferenceList = self.individualProfileCKRecord.objectForKey("interviews") as! [CKReference]
                }
                interviewReferenceList.append(CKReference(record: interviewRecord, action: .None))
                self.individualProfileCKRecord.setObject(interviewReferenceList, forKey: "interviews")
                
                publicDatabase.saveRecord(self.individualProfileCKRecord) { (record, error) -> Void in
                    if let error = error {
                        print(error)
                    }
                    else {
                        self.saveToActiveInterviews()
                        print("Success")
                    }
                }
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
