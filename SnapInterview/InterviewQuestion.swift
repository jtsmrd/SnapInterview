//
//  InterviewQuestion.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/21/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import Foundation
import CoreData

class InterviewQuestion: NSManagedObject {

    override func awakeFromInsert() {
        super.awakeFromInsert()
        question = ""
        timeLimitInSeconds = 0
        cKRecordName = ""
    }
}
