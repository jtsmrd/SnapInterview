//
//  InterviewTemplate.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/26/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import Foundation
import CoreData


class InterviewTemplate: NSManagedObject {

    override func awakeFromInsert() {
        super.awakeFromInsert()
        jobTitle = ""
        jobDescription = ""
        cKRecordName = ""
    }
}
