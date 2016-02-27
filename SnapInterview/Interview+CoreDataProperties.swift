//
//  Interview+CoreDataProperties.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/26/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Interview {

    @NSManaged var createDate: NSDate?
    @NSManaged var cKRecordName: String?
    @NSManaged var completeDate: NSDate?
    @NSManaged var videoDataKey: String?
    @NSManaged var businessProfile: BusinessProfile?
    @NSManaged var individualProfile: IndividualProfile?
    @NSManaged var interviewTemplate: InterviewTemplate?
}
