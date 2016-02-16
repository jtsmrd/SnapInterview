//
//  InterviewStore.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/9/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import Foundation
import UIKit

class InterviewStore {
    
    var allInterviews = [Interview]()
    
    init() {
        for _ in 0..<5 {
            createInterview()
        }
    }
    
    func createInterview() -> Interview {
        let newInterview = Interview(random: true)
        allInterviews.append(newInterview)
        return newInterview
    }
    
    func removeItem(interview: Interview) {
        if let index = allInterviews.indexOf(interview) {
            allInterviews.removeAtIndex(index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allInterviews[fromIndex]
        allInterviews.removeAtIndex(fromIndex)
        allInterviews.insert(movedItem, atIndex: toIndex)
    }
}