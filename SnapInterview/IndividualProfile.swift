//
//  IndividualProfile.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/15/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit

class IndividualProfile: NSObject {

    var firstName: String
    var lastName: String
    var email: String
    var profileImageKey: String
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profileImageKey = ""
    }
}
