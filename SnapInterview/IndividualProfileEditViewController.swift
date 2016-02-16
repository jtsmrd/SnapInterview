//
//  EditViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/4/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit

class IndividualProfileEditViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var individualProfile: IndividualProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileData()
    }
    
    @IBAction func addEditImageAction() {
        
    }
    
    @IBAction func cancelAction() {
        
    }
    
    @IBAction func saveAction() {
        
    }
    
    func setupProfileData() {
        
        if individualProfile != nil {
            firstNameTextField.text = individualProfile.firstName
            lastNameTextField.text = individualProfile.lastName
        }
    }
}