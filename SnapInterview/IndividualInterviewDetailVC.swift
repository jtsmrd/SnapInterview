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

class IndividualInterviewDetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var interviewTitleLabel: UILabel!
    @IBOutlet weak var interviewDescriptionLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    var interview: TestInterview!
    var videoStore = VideoStore()
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    
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
    
    var videoURL: NSURL!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
        //videoStore.setVideo(videoURL, forKey: "video1.mov")
        //print(videoURL)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func playInterview() {
        
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = AVPlayer(URL: videoURL)
        videoPlayer.player?.play()
        presentViewController(videoPlayer, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        interviewTitleLabel.text = interview.interviewTitle
        interviewDescriptionLabel.text = interview.interviewDescription
        dateCreatedLabel.text = dateFormatter.stringFromDate(interview.dateCreated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
