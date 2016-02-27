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
    
    var interviews: [Interview] = []
    var businessProfile: BusinessProfile!
    let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
    var businessProfileCKR: CKRecord!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        businessProfile = DataMethods.fetchBusinessProfile(userEmail!)
        interviews = businessProfile.interviews?.allObjects as! [Interview]
        tableView.reloadData()
    }
    
    // MARK: - Private Methods

    
    
    // MARK: - Table View Data Source Methods

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
    
    // MARK: - Navigation Methods

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createInterview" {
            let createInterviewVC = segue.destinationViewController as! CreateInterviewVC
            createInterviewVC.businessProfile = businessProfile
            createInterviewVC.businessProfileCKRecordID = businessProfile.businessProfileCKRecordID
        }
        else if segue.identifier == "showDetail" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = interviews[row]
                let interviewDetailVC = segue.destinationViewController as! BusinessInterviewDetailVC
                interviewDetailVC.interview = item
            }
        }
    }
}
