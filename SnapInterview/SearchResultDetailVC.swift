//
//  SearchResultDetailVC.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/23/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CloudKit

class SearchResultDetailVC: UIViewController {

    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var individualProfile: CKRecord!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstName = individualProfile.objectForKey("firstName") as? String {
            firstNameLabel.text = firstName
        }
        if let lastName = individualProfile.objectForKey("lastName") as? String {
            lastNameLabel.text = lastName
        }
        if let title = individualProfile.objectForKey("jobTitle") as? String {
            titleLabel.text = title
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sendInterviewAction(sender: UIButton) {
        
    }
    
    // MARK: - Private Methods
    // MARK: - Delegate Methods
    // MARK: - Datasource Methods
    // MARK: - Navigation Methods
}
