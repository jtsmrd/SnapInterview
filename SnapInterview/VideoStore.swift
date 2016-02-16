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
    
//    func videoForKey(key: String) -> UIImage? {
//        
//        if let existingImage = cache.objectForKey(key) as? UIImage {
//            return existingImage
//        }
//        
//        let imageURL = imageURLForKey(key)
//        
//        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
//            return nil
//        }
//        
//        cache.setObject(imageFromDisk, forKey: key)
//        return imageFromDisk
//    }
    
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
