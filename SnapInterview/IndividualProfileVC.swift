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

class IndividualProfileVC: UIViewController {
    
    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!    
    @IBOutlet weak var titleLabel: UILabel!
    var imageStore: ImageStore!
    var individualProfile: IndividualProfile!
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
    
    // MARK: - Private Methods

    private func setupView() {
        individualProfile = DataMethods.fetchIndividualProfile(userEmail!)
        
        firstNameLabel.text = individualProfile.firstName
        lastNameLabel.text = individualProfile.lastName
        titleLabel.text = individualProfile.jobTitle
        
        // If a profile picture exists, load it
        if let imageKey = individualProfile.profileImageKey {
            imageView.image = imageStore.imageForKey(imageKey)
        }
    }
    
    // MARK: - Navigation Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEdit" {            
            let destinationVC = segue.destinationViewController as! EditIndividualProfileVC
            destinationVC.individualProfile = individualProfile
        }
    }
}

