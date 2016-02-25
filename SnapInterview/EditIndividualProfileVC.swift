//
//  EditIndividualProfileViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/16/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class EditIndividualProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var individualProfile: IndividualProfile!
    var photoURL: NSURL?
    var currentRecord: CKRecord!
    var imageStore: ImageStore!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageStore = (UIApplication.sharedApplication().delegate as! AppDelegate).imageStore
        firstNameTextField.text = individualProfile.firstName
        lastNameTextField.text = individualProfile.lastName
        titleTextField.text = individualProfile.jobTitle
        loadProfileImage()
    }
    
    // MARK: - Actions
    
    @IBAction func saveAction(sender: UIButton) {
        saveIndividualProfile()
    }
    
    @IBAction func addEditImage(sender: UIButton) {
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
    
    // MARK: - Private Methods
    
    private func loadProfileImage() {
        imageView.image = imageStore.imageForKey(individualProfile.profileImageKey!)
    }
    
    // Save profile data to CoreData
    private func saveIndividualProfile() {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let title = titleTextField.text!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        individualProfile.firstName = firstName
        individualProfile.lastName = lastName
        individualProfile.jobTitle = title
        
        do {
            try coreDataStack.saveChanges()
            syncIndividualProfileToCloud()
        }
        catch let error {
            print(error)
        }
    }
    
    private func syncIndividualProfileToCloud() {
        var record: CKRecord!
        let predicate = NSPredicate(format: "email = %@", individualProfile.email!)
        let query = CKQuery(recordType: "IndividualProfile", predicate: predicate)
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { (records, error) -> Void in
            if let error = error {
                print(error)
            }
            else {
                if records!.count > 0 {
                    record = records![0]
                    record.setValue(self.firstNameTextField.text, forKey: "firstName")
                    record.setValue(self.lastNameTextField.text, forKey: "lastName")
                    record.setValue(self.titleTextField.text, forKey: "jobTitle")
                    if let imageID = self.individualProfile.profileImageKey {
                        let imageAsset = CKAsset(fileURL: self.imageStore.imageURLForKey(imageID))
                        record.setValue(imageAsset, forKey: "individualProfileImage")
                    }
                    publicDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
                        if let error = error {
                            print(error)
                        }
                    })
                }
            }
        })
    }
    
    // MARK: - Image Picker Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Get the image, assign it an image id, add it to the object and save
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        let imageKey = NSUUID().UUIDString
        individualProfile.profileImageKey = imageKey
        imageStore.setImage(image, forKey: imageKey)        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
