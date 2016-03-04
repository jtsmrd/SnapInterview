//
//  IndividualProfile.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/16/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import Foundation
import CoreData

class IndividualProfile: NSManagedObject {

    override func awakeFromInsert() {
        super.awakeFromInsert()
        individualProfileCKRecordName = ""
        email = ""
        firstName = ""
        profession = ""
        lastName = ""
        profileImageKey = ""
        individualProfileFirebaseUID = ""
        profileImageCKRecordName = ""
    }
}
