//
//  Interview+CoreDataProperties.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/25/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Interview {

    @NSManaged var createDate: NSDate?
    @NSManaged var desc: String?
    @NSManaged var interviewCKRecordID: String?
    @NSManaged var title: String?
    @NSManaged var businessProfile: BusinessProfile?
    @NSManaged var interviewQuestions: NSSet?
    @NSManaged var individualProfile: IndividualProfile?
}
