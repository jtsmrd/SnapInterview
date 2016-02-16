//
//  Interview.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/9/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import Foundation
import UIKit

class Interview: NSObject {
    
    var interviewTitle: String
    var interviewDescription: String
    let dateCreated: NSDate
    
    init(interviewTitle: String, interviewDescription: String) {
        self.interviewTitle = interviewTitle
        self.interviewDescription = interviewDescription
        self.dateCreated = NSDate()
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let titles = ["Google Interview", "Apple Interview", "SmrdTech Interview", "Amazon Interview"]
            let descriptions = ["Interview for an iOS Developer position", "Interview for an iOS Animation Developer position", "Interview for a Senior iOS Developer position", "Interview for a Development Manager position"]
            
            var idx = arc4random_uniform(UInt32(titles.count))
            let randomTitle = titles[Int(idx)]
            
            idx = arc4random_uniform(UInt32(descriptions.count))
            let randomDescription = descriptions[Int(idx)]
            
            self.init(interviewTitle: randomTitle, interviewDescription: randomDescription)
        }
        else {
            self.init(interviewTitle: "", interviewDescription: "")
        }
    }
}