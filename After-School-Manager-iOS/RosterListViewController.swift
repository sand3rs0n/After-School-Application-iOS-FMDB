//
//  RosterListViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class RosterListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var rosterListModel = RosterListModel()
    @IBOutlet weak var titleBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = rosterListModel.getTitleValue()
        if(rosterListModel.getState() != 2) {
            self.titleBar.rightBarButtonItem = nil
        }
        rosterListModel.getRosters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setState(state: Int) {
        rosterListModel.setState(state)
    }
    func setTitleValue(title: String) {
        rosterListModel.setTitleValue(title)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = rosterListModel.getRoster(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        let name = roster.getName()
        let startDate = Date(day: roster.getStartDay(), month: roster.getStartMonth(), year: roster.getStartYear())
        let endDate = Date(day: roster.getEndDay(), month: roster.getEndMonth(), year: roster.getEndYear())
        let date = startDate.fullDateAmerican() + " - " + endDate.fullDateAmerican()
        cell.textLabel?.text = "\(name)"
        cell.textLabel?.font  = UIFont(name: "Arial", size: 30.0)
        cell.detailTextLabel?.text = "\(date)"
        cell.detailTextLabel?.font  = UIFont(name: "Arial", size: 30.0)
        cell.detailTextLabel?.textAlignment = NSTextAlignment.Right
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterListModel.getRosterCount()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let roster = rosterListModel.getRoster(indexPath.row)
        rosterListModel.setForwardedRosterName(roster.getName())
        rosterListModel.setForwardedRosterID(roster.getRosterID())
        rosterListModel.setForwardedRosterType(roster.getRosterType())
        performSegueWithIdentifier("RosterSelectToStudentRoster", sender: self)
    }
    
    @IBAction func back(sender: AnyObject) {
        if (rosterListModel.getState() == 1) {
            performSegueWithIdentifier("ReturnHomeFromRosterSelect", sender: self)
        } else if (rosterListModel.getState() == 2) {
            performSegueWithIdentifier("ReturnToUpcomingAbsencesFromRosterSelect", sender: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let srvc = segue.destinationViewController as? StudentRosterViewController
        srvc?.setState(rosterListModel.getState())
        srvc?.setRosterID(rosterListModel.getForwardedRosterID())
        srvc?.setRosterType(rosterListModel.getForwardedRosterType())
        srvc?.setTitleValue(rosterListModel.getForwardedRosterName())
    }

    @IBAction func rosterSelectUnwind(segue: UIStoryboardSegue) {
    }
}
