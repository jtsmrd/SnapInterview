//
//  BusinessInterviewTVC.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/18/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class BusinessInterviewTVC: UITableViewController {

    // MARK: - Variables, Outlets, and Constants
    
    var interviews: NSArray!
    var businessProfile: BusinessProfile!
    let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        businessProfile = fetchBusinessProfile()
        tableView.reloadData()
    }
    
    // MARK: - Private Methods

    // Load from CoreData, return an IndividualProfile
    private func fetchBusinessProfile() -> BusinessProfile {
        var businessProfile: BusinessProfile!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        let fetchRequest = NSFetchRequest(entityName: "BusinessProfile")
        fetchRequest.predicate = NSPredicate(format: "email = %@", userEmail!)
        coreDataStack.mainQueueContext.performBlockAndWait() {
            do {
                let records = try coreDataStack.mainQueueContext.executeFetchRequest(fetchRequest) as? [BusinessProfile]
                businessProfile = records![0]
                self.interviews = businessProfile.interviews?.allObjects
            }
            catch let error {
                print(error)
            }
        }
        return businessProfile
    }
    
    // MARK: - Table View Data Source Methods

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interviews.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InterviewCell", forIndexPath: indexPath)
        let item = interviews[indexPath.row] as! Interview
        cell.textLabel?.text = item.title
        return cell
    }
    
    // MARK: - Navigation Methods

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createInterview" {
            let createInterviewVC = segue.destinationViewController as! CreateInterviewVC
            createInterviewVC.businessProfile = businessProfile
        }
        else if segue.identifier == "showDetail" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = interviews[row]
                let interviewDetailVC = segue.destinationViewController as! BusinessInterviewDetailVC
                interviewDetailVC.interview = item as! Interview
            }
        }
    }
}
