//
//  InterviewDetailViewController.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/9/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

// Update to load interview details from InterviewTemplate
class IndividualInterviewDetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var interviewTitleLabel: UILabel!
    @IBOutlet weak var interviewDescriptionLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    var interview: Interview!
    var videoStore = VideoStore()
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    var videoURL: NSURL!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        interviewTitleLabel.text = interview.interviewTemplate?.jobTitle
        interviewDescriptionLabel.text = interview.interviewTemplate?.jobDescription
        dateCreatedLabel.text = dateFormatter.stringFromDate(interview.createDate!)
    }
    
    // MARK: - Actions
    
    @IBAction func startInterview() {
        let imagePicker = UIImagePickerController()
        
        // If the device has a camera, take a picture; otherwise,
        // just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            imagePicker.mediaTypes = ["public.movie"]
        }
        else {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.delegate = self
        
        // Place image picker on the screen
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func playInterview() {
        
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = AVPlayer(URL: videoURL)
        videoPlayer.player?.play()
        presentViewController(videoPlayer, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    
    
    // MARK: - Image Picker Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
        //videoStore.setVideo(videoURL, forKey: "video1.mov")
        //print(videoURL)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
