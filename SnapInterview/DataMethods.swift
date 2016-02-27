//
//  DataMethods.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/25/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class DataMethods {
    
    static let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
    static let imageStore = (UIApplication.sharedApplication().delegate as! AppDelegate).imageStore
    static let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
    
    // Load from CoreData, return an IndividualProfile
    static func fetchIndividualProfile(userEmail: String) -> IndividualProfile {
        var individualProfile: IndividualProfile!
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
    
    // Save profile data to CoreData
    static func saveAndSyncIndividualProfile(individualProfile: IndividualProfile) {
        do {
            try coreDataStack.saveChanges()
            syncIndividualProfileToCloud(individualProfile)
        }
        catch let error {
            print(error)
        }
    }
    
    // Save IndividualProfile to the cloud
    static func syncIndividualProfileToCloud(individualProfile: IndividualProfile) {
        publicDatabase.fetchRecordWithID(CKRecordID.init(recordName: individualProfile.cKRecordName!)) { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let record = record {
                record.setValue(individualProfile.firstName, forKey: "firstName")
                record.setValue(individualProfile.lastName, forKey: "lastName")
                record.setValue(individualProfile.jobTitle, forKey: "jobTitle")
                if ((individualProfile.profileImageKey?.isEmpty) == nil) {
                    let imageAsset = CKAsset(fileURL: imageStore.imageURLForKey(individualProfile.profileImageKey!))
                    record.setValue(imageAsset, forKey: "individualProfileImage")
                }
                publicDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
                    if let error = error {
                        print(error)
                    }
                })
            }
        }
    }
    
    // Fix to use InterviewTemplate data
    static func fetchAndStoreNewInterviews(individualProfile: IndividualProfile) {
        publicDatabase.fetchRecordWithID(CKRecordID.init(recordName: individualProfile.cKRecordName!)) { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let profileRecord = record {
                if profileRecord.objectForKey("interviews") != nil {
                    let interviewReferences = profileRecord.objectForKey("interviews") as! [CKReference]
                    for interviewReference in interviewReferences {
                        let matches = (individualProfile.interviews!.allObjects as! [Interview]).filter { $0.cKRecordName == interviewReference.recordID.recordName }
                        if matches.isEmpty {
                            publicDatabase.fetchRecordWithID(interviewReference.recordID, completionHandler: { (record, error) -> Void in
                                if let error = error {
                                    print(error)
                                }
                                else if let interviewRecord = record {
                                    
                                    var interview: Interview!
                                    coreDataStack.mainQueueContext.performBlockAndWait({ () -> Void in
                                        interview = NSEntityDescription.insertNewObjectForEntityForName("Interview", inManagedObjectContext: coreDataStack.mainQueueContext) as! Interview
                                        //interview.title = interviewRecord.valueForKey("title") as? String
                                        //interview.desc = interviewRecord.valueForKey("description") as? String
                                        interview.individualProfile = individualProfile
                                        interview.cKRecordName = interviewRecord.recordID.recordName
                                    })
                                    do {
                                        try coreDataStack.saveChanges()
                                        NSLog("Interview saved")
                                    }
                                    catch let error {
                                        print(error)
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    // Load from CoreData, return an IndividualProfile
    static func fetchBusinessProfile(userEmail: String) -> BusinessProfile {
        var businessProfile: BusinessProfile!
        let fetchRequest = NSFetchRequest(entityName: "BusinessProfile")
        fetchRequest.predicate = NSPredicate(format: "email = %@", userEmail)
        coreDataStack.mainQueueContext.performBlockAndWait() {
            do {
                let records = try coreDataStack.mainQueueContext.executeFetchRequest(fetchRequest) as? [BusinessProfile]
                businessProfile = records![0]                
            }
            catch let error {
                print(error)
            }
        }
        return businessProfile
    }
    
    // Save profile data to CoreData
    static func saveAndSyncBusinessProfile(businessProfile: BusinessProfile) {
        do {
            try coreDataStack.saveChanges()
            syncBusinessProfileToCloud(businessProfile)
        }
        catch let error {
            print(error)
        }
    }
    
    // Save BusinessProfile to the cloud
    static func syncBusinessProfileToCloud(businessProfile: BusinessProfile) {
        publicDatabase.fetchRecordWithID(CKRecordID.init(recordName: businessProfile.cKRecordName!)) { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let record = record {
                record.setValue(businessProfile.firstName, forKey: "firstName")
                record.setValue(businessProfile.lastName, forKey: "lastName")
                record.setValue(businessProfile.businessName, forKey: "businessName")
                if ((businessProfile.profileImageKey?.isEmpty) == nil) {
                    let imageAsset = CKAsset(fileURL: imageStore.imageURLForKey(businessProfile.profileImageKey!))
                    record.setValue(imageAsset, forKey: "businessProfileImage")
                }
                publicDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
                    if let error = error {
                        print(error)
                    }
                })
            }
        }
    }
}