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

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var individualProfile: IndividualProfile!
    var photoURL: NSURL?
    var currentRecord: CKRecord!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.text = individualProfile.firstName
        lastNameTextField.text = individualProfile.lastName
    }
    
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
            //syncIndividualProfileToCloud()
        }
        catch let error {
            print(error)
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
