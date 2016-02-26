//
//  DataMethods.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/25/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData

class DataMethods {
    
    // Load from CoreData, return an IndividualProfile
    static func fetchIndividualProfile(userEmail: String) -> IndividualProfile {
        var individualProfile: IndividualProfile!
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        let fetchRequest = NSFetchRequest(entityName: "IndividualProfile")
        fetchRequest.predicate = NSPredicate(format: "email = %@", userEmail)
        coreDataStack.mainQueueContext.performBlockAndWait() {
            do {
                let records = try coreDataStack.mainQueueContext.executeFetchRequest(fetchRequest) as? [IndividualProfile]
                individualProfile = records![0]
            }
            catch let error {
                print(error)
            }
        }
        return individualProfile
    }
}