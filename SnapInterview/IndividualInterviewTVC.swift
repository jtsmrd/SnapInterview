//
//  InterviewTableViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/9/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class IndividualInterviewTVC: UITableViewController {

    // MARK: - Variables, Outlets, and Constants
    
    var interviewStore = InterviewStore()
    var individualProfile: IndividualProfile!
    let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
    var cloudInterviews = [CKRecord]()
    var interviews: [Interview] = []
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        self.refreshControl?.addTarget(self, action: "addTestInterview", forControlEvents: .ValueChanged)
        
        individualProfile = fetchIndividualProfile()
        //addTestInterview()
        fetchInterviews()
        individualProfile = fetchIndividualProfile()
    }

    // MARK: - Actions
    
    
    
    // MARK: - Private Methods
    
    func addTestInterview() {
        var newInterview: Interview!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        coreDataStack.mainQueueContext.performBlockAndWait { () -> Void in
            newInterview = NSEntityDescription.insertNewObjectForEntityForName("Interview", inManagedObjectContext: coreDataStack.mainQueueContext) as! Interview
            newInterview.title = "Interview \(NSDate())"
            newInterview.desc = "Description"
            newInterview.individualProfile = self.individualProfile
        }
//        interviews.addObject(newInterview)
        self.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    // Load from CoreData, return an IndividualProfile
    private func fetchIndividualProfile() -> IndividualProfile {
        var individualProfile: IndividualProfile!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        let fetchRequest = NSFetchRequest(entityName: "IndividualProfile")
        fetchRequest.predicate = NSPredicate(format: "email = %@", userEmail!)
        coreDataStack.mainQueueContext.performBlockAndWait() {
            do {
                let records = try coreDataStack.mainQueueContext.executeFetchRequest(fetchRequest) as? [IndividualProfile]
                individualProfile = records![0]
                self.interviews = individualProfile.interviews?.allObjects as! [Interview]
            }
            catch let error {
                print(error)
            }
        }
        return individualProfile
    }
    
    private func fetchInterviews() {
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        publicDatabase.fetchRecordWithID(CKRecordID.init(recordName: individualProfile.individualProfileCKRecordID!)) { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let record = record {
                //let record = records[0]
                if record.objectForKey("interviews") != nil {
                    let references: [CKReference] = record.objectForKey("interviews") as! [CKReference]
                    for reference in references {
                        let matches = self.interviews.filter { $0.interviewCKRecordID == reference.recordID.recordName }
                        if matches.isEmpty {
                            publicDatabase.fetchRecordWithID(reference.recordID, completionHandler: { (record, error) -> Void in
                                // Convert record into Interview, save and associate with IndividualProfile
                                if let error = error {
                                    print(error)
                                }
                                else if let record = record {
                                    var interview: Interview!
                                    let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
                                    interview = NSEntityDescription.insertNewObjectForEntityForName("Interview", inManagedObjectContext: coreDataStack.mainQueueContext) as! Interview
                                    interview.title = record.valueForKey("title") as? String
                                    interview.desc = record.valueForKey("description") as? String
                                    interview.individualProfile = self.individualProfile
                                    interview.interviewCKRecordID = record.recordID.recordName
                                    
                                    do {
                                        try coreDataStack.saveChanges()
                                        NSLog("Core Data saved")
                                    }
                                    catch let error1 {
                                        print(error1)
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Table View Datasource Methods

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interviews.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InterviewCell", forIndexPath: indexPath)
        let item = interviews[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            let interview = interviewStore.allInterviews[indexPath.row]
//            interviewStore.removeItem(interview)            
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
    
    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//        interviewStore.moveItemAtIndex(fromIndexPath.row, toIndex: toIndexPath.row)
//    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation Methods

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showInterviewDetail" {
            if let rowIndex = tableView.indexPathForSelectedRow?.row {
                let interview = interviews[rowIndex]
                let interviewDetailViewController = segue.destinationViewController as! IndividualInterviewDetailVC
                interviewDetailViewController.interview = interview
            }
        }
    }
}
