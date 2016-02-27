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

class EditBusinessProfileVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    var businessProfile: BusinessProfile!
    var photoURL: NSURL?
    var currentRecord: CKRecord!
    var imageStore: ImageStore!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageStore = (UIApplication.sharedApplication().delegate as! AppDelegate).imageStore
        firstNameTextField.text = businessProfile.firstName
        lastNameTextField.text = businessProfile.lastName
        businessNameTextField.text = businessProfile.businessName
        loadProfileImage()
    }
    
    // MARK: - Actions
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
        businessProfile.firstName = firstNameTextField.text!
        businessProfile.lastName = lastNameTextField.text!
        businessProfile.businessName = businessNameTextField.text!
        DataMethods.saveAndSyncBusinessProfile(businessProfile)
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func loadProfileImage() {
        imageView.image = imageStore.imageForKey(businessProfile.profileImageKey!)
    }
    
    // MARK: TextField Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    // MARK: - Image Picker Delegate Methods
    
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
