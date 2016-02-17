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
    let userEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        
        individualProfile = fetchIndividualProfile()
        
        firstNameLabel.text = individualProfile.firstName
        lastNameLabel.text = individualProfile.lastName
        
        
        // If a profile picture exists, load it
//        if let imageKey = individualProfile.profileImageKey {
//            imageView.image = imageStore.imageForKey(imageKey)
//        }
    }
    
    // Load from CoreData, return an IndividualProfile
    private func fetchIndividualProfile() -> IndividualProfile {
        
        var individualProfile: IndividualProfile!
        let coreDataStack = CoreDataStack(modelName: "SnapInterviewEntities")
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
    
    // Reload the InvidualProfile
    @IBAction func unwindAfterIndividualProfileEdit(segue: UIStoryboardSegue) {
//        if let editViewController = segue.sourceViewController as? EditIndividualProfileViewController {
//            if editViewController.profileUpdated {
//                setupView()
//            }
//        }
        
        setupView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEdit" {            
            let destinationVC = segue.destinationViewController as! EditIndividualProfileViewController
            destinationVC.individualProfile = fetchIndividualProfile()
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

