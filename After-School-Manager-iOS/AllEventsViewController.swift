//
//  AllEventsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class AllEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var eventsListTable: UITableView!
    private var eventList = [Event]()
    private var forwardedEvent = Event()

    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getEvents() {
        let querySQL = "SELECT * FROM EVENTS ORDER BY year, month, day, name ASC"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Event()
            cur.setEventID(Int(results.intForColumn("eventID")))
            cur.setEventType(Int(results.intForColumn("eventType")))
            cur.setName(results.stringForColumn("name"))
            cur.setDescription(results.stringForColumn("description"))
            cur.setDay(Int(results.intForColumn("day")))
            cur.setMonth(Int(results.intForColumn("month")))
            cur.setYear(Int(results.intForColumn("year")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            eventList.append(cur)
        }
        results.close()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = eventList[(indexPath.row)]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = roster.getName()
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event = eventList[(indexPath.row)]
        forwardedEvent = event
        performSegueWithIdentifier("AllEventsToEditEvent", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let aoeevc = segue.destinationViewController as? AddOrEditEventViewController
        if (segue.identifier == "AllEventsToAddEvent") {
            aoeevc?.setTitleValue("Add Event")
            aoeevc?.setButtonText("Create Event")
        } else if (segue.identifier == "AllEventsToEditEvent") {
            aoeevc?.setTitleValue("Edit Event")
            aoeevc?.setButtonText("Edit Event")
            aoeevc?.setEvent(forwardedEvent)
            aoeevc?.setState(1)
        }
    }

    @IBAction func allEventsUnwind(segue: UIStoryboardSegue) {
        eventList.removeAll()
        getEvents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.eventsListTable.reloadData()
        })
    }
}
