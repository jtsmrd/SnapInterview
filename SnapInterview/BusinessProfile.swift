//
//  BusinessProfile.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/18/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import Foundation
import CoreData


class BusinessProfile: NSManagedObject {

    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        firstName = ""
        lastName = ""
        email = ""
        businessName = ""
        profileImageKey = ""
    }
}
