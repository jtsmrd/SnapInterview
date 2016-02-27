//
//  IndividualSearchVC.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/23/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CloudKit

// Fetch BusinessProfile and send it to SearchResultDetailVC
class IndividualSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var individualProfiles = [CKRecord]()
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchIndividualProfiles()
    }
    
    // MARK: - Private Methods
    
    private func fetchIndividualProfiles() {
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        let query = CKQuery(recordType: "IndividualProfile", predicate: NSPredicate(format: "TRUEPREDICATE"))
        query.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        publicDatabase.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let records = records {
                    self.individualProfiles = records
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: - Table View Datasource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return individualProfiles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IndividualProfileCell", forIndexPath: indexPath)
        let item = individualProfiles[indexPath.row]
        let firstName = item.objectForKey("firstName") as? String
        let lastName = item.objectForKey("lastName") as? String
        cell.textLabel?.text = firstName! + " " + lastName!
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showIndividualDetails" {
            let searchResultDetailVC = segue.destinationViewController as! SearchResultDetailVC
            searchResultDetailVC.individualProfile = individualProfiles[tableView.indexPathForSelectedRow!.row]
        }
    }
}
