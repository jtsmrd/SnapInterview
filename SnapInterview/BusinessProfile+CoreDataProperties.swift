//
//  BusinessProfile+CoreDataProperties.swift
//  SnapInterview
//
//  Created by JT Smrdel on 3/4/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BusinessProfile {

    @NSManaged var businessName: String?
    @NSManaged var businessProfileCKRecordName: String?
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var profileImageKey: String?
    @NSManaged var businessProfileFirebaseUID: String?
    @NSManaged var profileImageCKRecordName: String?
    @NSManaged var interviews: NSSet?
    @NSManaged var interviewTemplates: NSSet?
}
