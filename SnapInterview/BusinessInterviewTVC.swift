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

    var interviews: NSArray!
    var businessProfile: BusinessProfile!
    let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        businessProfile = fetchBusinessProfile()
    }

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
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return interviews.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InterviewCell", forIndexPath: indexPath)

        let item = interviews[indexPath.row] as! Interview
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

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createInterview" {
            let createInterviewVC = segue.destinationViewController as! CreateInterviewVC
            createInterviewVC.businessProfile = businessProfile
        }
    }
}
