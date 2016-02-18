//
//  EditBusinessProfileVC.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/18/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class EditBusinessProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    var businessProfile: BusinessProfile!
    var photoURL: NSURL?
    var currentRecord: CKRecord!
    var imageStore: ImageStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageStore = (UIApplication.sharedApplication().delegate as! AppDelegate).imageStore
        
        firstNameTextField.text = businessProfile.firstName
        lastNameTextField.text = businessProfile.lastName
        businessNameTextField.text = businessProfile.businessName
        
        loadProfileImage()
    }

    @IBAction func addEditImageAction(sender: UIButton) {
        
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
    
    @IBAction func saveAction(sender: UIButton) {
        
        saveBusinessProfile()
    }
    
    private func loadProfileImage() {
        
        imageView.image = imageStore.imageForKey(businessProfile.profileImageKey!)
    }
    
    // Save profile data to CoreData
    private func saveBusinessProfile() {
        
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let businessName = businessNameTextField.text!
        
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        
        businessProfile.firstName = firstName
        businessProfile.lastName = lastName
        businessProfile.businessName = businessName
        
        do {
            try coreDataStack.saveChanges()
            //syncBusinessProfileToCloud()
        }
        catch let error {
            print(error)
        }
    }
    
    private func syncBusinessProfileToCloud() {
        
        var record: CKRecord!
        let predicate = NSPredicate(format: "email = %@", businessProfile.email!)
        let query = CKQuery(recordType: "BusinessProfile", predicate: predicate)
        
        CKContainer.defaultContainer().publicCloudDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { (records, error) -> Void in
            
            if let error = error {
                print(error)
            }
            else {
                if records!.count > 0 {
                    record = records![0]
                    
                    record.setValue(self.firstNameTextField.text, forKey: "firstName")
                    record.setValue(self.lastNameTextField.text, forKey: "lastName")
                    record.setValue(self.businessNameTextField.text, forKey: "businessName")
                    
                    if let imageID = self.businessProfile.profileImageKey {
                        let imageAsset = CKAsset(fileURL: self.imageStore.imageURLForKey(imageID))
                        record.setValue(imageAsset, forKey: "businessProfileImage")
                    }
                    
                    CKContainer.defaultContainer().publicCloudDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
                        if let error = error {
                            print(error)
                        }
                    })
                }
            }
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Get the image, assign it an image id, add it to the object and save
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        let imageKey = NSUUID().UUIDString
        businessProfile.profileImageKey = imageKey
        imageStore.setImage(image, forKey: imageKey)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
