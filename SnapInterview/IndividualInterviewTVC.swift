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

// Update to load interview details from InterviewTemplate
class IndividualInterviewTVC: UITableViewController {

    // MARK: - Variables, Outlets, and Constants
    
    var individualProfile: IndividualProfile!
    let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
    var interviews: [Interview] = []
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        individualProfile = DataMethods.fetchIndividualProfile(userEmail!)
        //DataMethods.fetchAndStoreNewInterviews(individualProfile)
        individualProfile = DataMethods.fetchIndividualProfile(userEmail!)
        interviews = individualProfile.interviews?.allObjects as! [Interview]
    }

    // MARK: - Actions
    
    
    
    // MARK: - Private Methods
    

    
    // MARK: - Table View Datasource Methods

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interviews.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InterviewCell", forIndexPath: indexPath)
        //let item = interviews[indexPath.row]
//        cell.textLabel?.text = item.
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
