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
    var imageStore: ImageStore!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageStore = (UIApplication.sharedApplication().delegate as! AppDelegate).imageStore
        firstNameTextField.text = individualProfile.firstName
        lastNameTextField.text = individualProfile.lastName
        titleTextField.text = individualProfile.profession
        loadProfileImage()
    }
    
    // MARK: - Actions
    
    @IBAction func saveAction(sender: UIButton) {
        individualProfile.firstName = firstNameTextField.text!
        individualProfile.lastName = lastNameTextField.text!
        individualProfile.profession = titleTextField.text!
        DataMethods.saveAndSyncIndividualProfile(individualProfile)
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
