//
//  VideoStore.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/9/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit

class VideoStore: NSObject {

    // MARK: - Variables and Constants
    
    let cache = NSCache()
    
    // MARK: - Actions
    
    func videoURLForKey(key: String) -> NSURL {
        
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.URLByAppendingPathComponent(key)
    }
    
    func setVideo(video: NSURL, forKey key: String) {
        
        cache.setObject(video, forKey: key)
        
        // Create full URL for image
        let videoURL = videoURLForKey(key)
        
        // Turn image into JPEG data
        if let data = NSData(contentsOfURL: video) {
            
            // Write it to full URL
            data.writeToURL(videoURL, atomically: true)
        }
    }
    
    func videoForKey(key: String) -> NSData? {
        
        if let existingVideo = cache.objectForKey(key) as? NSData {
            return existingVideo
        }
        
        let videoURL = videoURLForKey(key)
        
        guard let videoFromDisk = NSData(contentsOfFile: videoURL.path!) else {
            return nil
        }
        
        cache.setObject(videoFromDisk, forKey: key)
        return videoFromDisk
    }
    
    func deleteVideoForKey(key: String) {
        
        cache.removeObjectForKey(key)
        
        let videoURL = videoURLForKey(key)
        
        do {
            try NSFileManager.defaultManager().removeItemAtURL(videoURL)
        }
        catch let deleteError {
            print("Error removing the video from the disk: \(deleteError)")
        }
    }
}
