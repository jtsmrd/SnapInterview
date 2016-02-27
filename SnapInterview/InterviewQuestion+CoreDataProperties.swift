//
//  InterviewQuestion+CoreDataProperties.swift
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

extension InterviewQuestion {

    @NSManaged var cKRecordName: String?
    @NSManaged var question: String?
    @NSManaged var timeLimitInSeconds: NSNumber?
    @NSManaged var interviewTemplate: InterviewTemplate?
}
