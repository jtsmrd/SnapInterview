//
//  BusinessInterviewDetailVC.swift
//  SnapInterview
//
//  Created by JT Smrdel on 2/21/16.
//  Copyright © 2016 SmrdelJT. All rights reserved.
//

import UIKit

class BusinessInterviewDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables, Outlets, and Constants
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var interview: Interview!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupView()
    }

    // MARK: - Actions
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        titleLabel.text = interview.title
        descriptionTextView.text = interview.desc
    }
    
    // MARK: - Table View Datasource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (interview.interviewQuestions?.allObjects.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell", forIndexPath: indexPath)
        let item = interview.interviewQuestions?.allObjects[indexPath.row] as! InterviewQuestion
        cell.textLabel?.text = item.question
        return cell
    }
}
