//
//  ProfileViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 1/28/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class IndividualProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!    
    @IBOutlet weak var titleLabel: UILabel!
    
    var imageStore: ImageStore!
    var individualProfile: IndividualProfile!
    let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageStore = (UIApplication.sharedApplication().delegate as! AppDelegate).imageStore
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    private func setupView() {
        
        individualProfile = fetchIndividualProfile()
        
        firstNameLabel.text = individualProfile.firstName
        lastNameLabel.text = individualProfile.lastName
        titleLabel.text = individualProfile.jobTitle
        
        // If a profile picture exists, load it
        if let imageKey = individualProfile.profileImageKey {
            imageView.image = imageStore.imageForKey(imageKey)
        }
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
            }
            catch let error {
                print(error)
            }
        }
        
        return individualProfile
    }
    
    @IBAction func logoutAction() {
        
        // Show new Login Controller
        
        // Set the logged in status to false, then show the login screen
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Reload the InvidualProfile
    @IBAction func unwindAfterIndividualProfileEdit(segue: UIStoryboardSegue) {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEdit" {            
            let destinationVC = segue.destinationViewController as! EditIndividualProfileVC
            destinationVC.individualProfile = fetchIndividualProfile()
        }
    }
}

