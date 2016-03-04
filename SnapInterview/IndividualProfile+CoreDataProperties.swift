//
//  IndividualProfile+CoreDataProperties.swift
//  SnapInterview
//
//  Created by JT Smrdel on 3/3/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension IndividualProfile {

    @NSManaged var individualProfileCKRecordName: String?
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var profession: String?
    @NSManaged var lastName: String?
    @NSManaged var profileImageKey: String?
    @NSManaged var individualProfileFirebaseUID: String?
    @NSManaged var profileImageCKRecordName: String?
    @NSManaged var interviews: NSSet?
}
