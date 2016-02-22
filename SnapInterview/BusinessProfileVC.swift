//
//  BusinessProfileVC.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/18/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class BusinessProfileVC: UIViewController {

    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    var imageStore: ImageStore!
    var businessProfile: BusinessProfile!
    let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageStore = (UIApplication.sharedApplication().delegate as! AppDelegate).imageStore
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    // MARK: - Actions
    
    @IBAction func logoutAction(sender: UIButton) {
        // Set the logged in status to false, then show the login screen
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Remove this and embed BusinessProfile in NavController
    @IBAction func unwindAfterBusinessProfileEdit(segue: UIStoryboardSegue) {
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        businessProfile = fetchBusinessProfile()
        firstNameLabel.text = businessProfile.firstName
        lastNameLabel.text = businessProfile.lastName
        businessNameLabel.text = businessProfile.businessName
        
        // If a profile picture exists, load it
        if let imageKey = businessProfile.profileImageKey {
            imageView.image = imageStore.imageForKey(imageKey)
        }
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
            }
            catch let error {
                print(error)
            }
        }
        return businessProfile
    }
    
    // MARK: - Navigation Methods

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEdit" {
            let destinationVC = segue.destinationViewController as! EditBusinessProfileVC
            destinationVC.businessProfile = fetchBusinessProfile()
        }
    }
}
