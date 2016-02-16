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

class IndividualProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!    
    @IBOutlet weak var titleLabel: UILabel!
    
    var imageStore: ImageStore!
    var individualProfile: IndividualProfile!
    var photoURL: NSURL?
    var currentRecord: CKRecord!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIndividualProfileData()
    }
    
    private func setupView() {
        
        if individualProfile != nil {
            firstNameLabel.text = individualProfile.firstName
            lastNameLabel.text = individualProfile.lastName
        }
        
//        let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
//        let predicate = NSPredicate(format: "email = %@", userEmail!)
//        let query = CKQuery(recordType: "IndividualProfile", predicate: predicate)
//        
//        CKContainer.defaultContainer().publicCloudDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { (records, error) -> Void in
//            
//            if let error = error {
//                print(error)
//            }
//            else {
//                if records!.count > 0 {
//                    self.currentRecord = records![0]
//                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.firstNameLabel.text = self.currentRecord.objectForKey("firstName") as? String
//                        self.lastNameLabel.text = self.currentRecord.objectForKey("lastName") as? String
//                        
//                        if let photo = self.currentRecord.objectForKey("profileImage") as? CKAsset {
//                            let image = UIImage(contentsOfFile: photo.fileURL.path!)
//                            self.imageView.image = image
//                        }
//                    })
//                }
//            }
//        })
    }
    
    // Load from CoreData, return an IndividualProfile
    private func loadIndividualProfileData() {
        
        let coreDataStack = CoreDataStack(modelName: "SnapInterviewEntities")
        let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
        let fetchRequest = NSFetchRequest(entityName: "IndividualProfile")
        fetchRequest.predicate = NSPredicate(format: "email = %@", userEmail!)
        
        coreDataStack.privateQueueContext.performBlockAndWait() {
            do {
                let records = try coreDataStack.privateQueueContext.executeFetchRequest(fetchRequest) as? [IndividualProfile]
                
                self.individualProfile = records!.first
            }
            catch let error {
                print(error)
            }
        }
        setupView()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Check NSUserDefaults to see if the user is still logged in
//        if !isLoggedIn() {
//            self.performSegueWithIdentifier("showLogin", sender: self)
//        }
//        else {
//            
//            // If a new profile wasn't just created, load profile data
//            if individualProfile == nil {
//                email = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
//                loadProfile(email)
//            }
//            
//            firstNameLabel.text = individualProfile.firstName
//            lastNameLabel.text = individualProfile.lastName
//            
//            // If a profile picture exists, load it
//            if let imageKey = individualProfile.profileImageKey {
//                imageView.image = imageStore.imageForKey(imageKey)
//            }
//        }
    }
    
    @IBAction func logoutAction() {
        
        // Show new Login Controller
        
        // Set the logged in status to false, then show the login screen
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Display the image picker to select a profile image
    @IBAction func addImage() {
        
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        }
        else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showEdit" {
            
            let destinationVC = segue.destinationViewController as! IndividualProfileEditViewController
            destinationVC.individualProfile = self.individualProfile
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Get the image, assign it an image id, add it to the object and save
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        photoURL = saveImageToFile(image)
        saveImageToCloud(photoURL!)
        
        //let imageKey = NSUUID().UUIDString
        //self.individualProfile.profileImageKey = imageKey
        
        //imageStore.setImage(image, forKey: imageKey)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImageToCloud(photoURL: NSURL) {
        
        let imageAsset = CKAsset(fileURL: photoURL)
        currentRecord.setValue(imageAsset, forKey: "profileImage")
        
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        publicDatabase.saveRecord(currentRecord, completionHandler: { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else {
                print("Done")
            }
        })
    }
    
    func saveImageToFile(image: UIImage) -> NSURL {
        
        let fileManager = NSFileManager.defaultManager()
        let directoryPaths = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let filePath = directoryPaths[0].URLByAppendingPathComponent("currentImage.jpg").path
        UIImageJPEGRepresentation(image, 0.5)!.writeToFile(filePath!, atomically: true)
        print(filePath!)
        return NSURL.fileURLWithPath(filePath!)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

