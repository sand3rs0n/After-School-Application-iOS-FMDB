//
//  CreateRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddOrEditRosterViewController: UIViewController {
    private var addOrEditRosterModel = AddOrEditRosterModel()

    @IBOutlet weak var rosterName: UITextView!
    @IBOutlet weak var rosterType: UIPickerView!
    @IBOutlet weak var pickUpTime: UIDatePicker!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var createRosterButton: UIButton!
    @IBOutlet weak var titleBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        endDate.hidden = true;
        endDateLabel.hidden = true;

        self.titleBar.title = addOrEditRosterModel.getTitleValue()
        self.createRosterButton!.setTitle(addOrEditRosterModel.getButtonText(), forState: .Normal)

        if (addOrEditRosterModel.getState() == 1) {
            fillElements()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent componenet: Int) -> Int {
        return addOrEditRosterModel.getOptionCount()
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return addOrEditRosterModel.getOption(row)
    }

    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        let selected = addOrEditRosterModel.getOption(row)
        if (selected == "Day Camp") {
            endDate.hidden = true;
            endDateLabel.hidden = true;
        } else {
            endDate.hidden = false;
            endDateLabel.hidden = false;
        }
    }

    func setState(state: Int) {
        addOrEditRosterModel.setState(state)
    }
    func setTitleValue(navTitle: String) {
        addOrEditRosterModel.setTitleValue(navTitle)
    }
    func setCreateRosterButtonValue(buttonText: String) {
        addOrEditRosterModel.setButtonText(buttonText)
    }
    func setExistingRoster(roster: Roster) {
        addOrEditRosterModel.setExistingRoster(roster)
    }

    private func fillElements() {
        //put stuff in proper fields
        let roster = addOrEditRosterModel.getExistingRoster()
        rosterName.text = roster.getName()

        rosterType.selectRow(roster.getRosterType(), inComponent: 0, animated: true)
        if (roster.getRosterType() > 0) {
            endDate.hidden = false;
            endDateLabel.hidden = false;
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        var dateString = String(roster.getStartDay()) + "/" + String(roster.getStartMonth()) + "/" + String(roster.getStartYear())
        var convertedStartDate = dateFormatter.dateFromString(dateString)
        startDate.date = convertedStartDate!

        dateString = String(roster.getEndDay()) + "/" + String(roster.getEndMonth()) + "/" + String(roster.getEndYear())
        convertedStartDate = dateFormatter.dateFromString(dateString)
        endDate.date = convertedStartDate!

        var hour = roster.getPickUpHour()
        var ampm = "AM"
        if (hour > 12) {
            hour = hour - 12
            ampm = "PM"
        }
        dateFormatter.dateFormat = "h:m:a"
        dateString = String(hour) +  ":" + String(roster.getPickUpMinute()) + ":" + ampm
        convertedStartDate = dateFormatter.dateFromString(dateString)
        pickUpTime.date = convertedStartDate!
    }

    @IBAction func backButton(sender: AnyObject) {
        back()
    }

    private func back() {
        if (addOrEditRosterModel.getState() == 0) {
            performSegueWithIdentifier("ReturnToAllRostersUnwind", sender: self)
        } else if (addOrEditRosterModel.getState() == 1) {
            performSegueWithIdentifier("ReturnToRosterUnwind", sender: self)
        }
    }

    @IBAction func createRoster(sender: AnyObject) {
        let selected = rosterType.selectedRowInComponent(0)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "MM/dd/yyyy"

        var inputDate = dateFormatter.stringFromDate(startDate.date)
        var dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
        let startDay = Int(dateArr[1])!
        let startMonth = Int(dateArr[0])!
        let startYear = Int(dateArr[2])!
        var weekday = 0
        if (addOrEditRosterModel.getOption(selected)  == "Day Camp") {
            endDate.setDate(startDate.date, animated: true)
            weekday = Date(day: startDay, month: startMonth, year: startYear).getWeekdayInt()
        }

        inputDate = dateFormatter.stringFromDate(endDate.date)
        dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
        let endDay = Int(dateArr[1])!
        let endMonth = Int(dateArr[0])!
        let endYear = Int(dateArr[2])!

        dateFormatter.dateFormat = "h:mm:a"
        inputDate = dateFormatter.stringFromDate(pickUpTime.date)
        dateArr = inputDate.characters.split{$0 == ":"}.map(String.init)
        if (dateArr[2] == "PM") {
            dateArr[0] = String(Int(dateArr[0])! + 12)
        }
        let pickUpHour = Int(dateArr[0])!
        let pickUpMinute = Int(dateArr[1])!

        var insertSQL = ""
        var updateSignOut = ""
        var updateStudentRosters = ""
        let rosterNameText = rosterName.text!.stringByReplacingOccurrencesOfString("'", withString: "''")
        if (rosterName.text != "") {
            var result2 = true
            var result3 = true
            if (addOrEditRosterModel.getState() == 1) {
                let existingRoster = addOrEditRosterModel.getExistingRoster()
                existingRoster.setName(rosterName.text!)
                existingRoster.setRosterType(selected)
                existingRoster.setStartDay(startDay)
                existingRoster.setStartMonth(startMonth)
                existingRoster.setStartYear(startYear)
                existingRoster.setEndDay(endDay)
                existingRoster.setEndMonth(endMonth)
                existingRoster.setEndYear(endYear)
                existingRoster.setPickUpHour(pickUpHour)
                existingRoster.setPickUpMinute(pickUpMinute)
                var weekBool = [0, 0, 0, 0, 0, 0, 0]
                weekBool[weekday] = 1

                insertSQL = "UPDATE ROSTERS SET rosterType = '\(selected)', name = '\(rosterNameText)', startDay = '\(startDay)', startMonth = '\(startMonth)', startYear = '\(startYear)', endDay = '\(endDay)', endMonth = '\(endMonth)', endYear = '\(endYear)', pickUpHour = '\(pickUpHour)', pickUpMinute = '\(pickUpMinute)' WHERE rosterID = '\(existingRoster.getRosterID())'"
                updateSignOut = "UPDATE SIGNOUTS SET rosterType = '\(selected)' WHERE rosterID = '\(existingRoster.getRosterID())'"
                if (selected == 0) {
                updateStudentRosters = "UPDATE STUDENTROSTERS SET rosterName = '\(rosterNameText)', monday = '\(weekBool[0])', tuesday = '\(weekBool[1])', wednesday = '\(weekBool[2])', thursday = '\(weekBool[3])', friday = '\(weekBool[4])', saturday = '\(weekBool[5])', sunday = '\(weekBool[6])' WHERE rosterID = '\(existingRoster.getRosterID())'"
                } else {
                    updateStudentRosters = "UPDATE STUDENTROSTERS SET rosterName = '\(rosterNameText)' WHERE rosterID = '\(existingRoster.getRosterID())'"
                }

                result2 = database.update(updateSignOut)
                result3 = database.update(updateStudentRosters)
            } else if (addOrEditRosterModel.getState() == 0) {
                insertSQL = "INSERT INTO ROSTERS (rosterType, name, startDay, startMonth, startYear, endDay, endMonth, endYear, pickUpHour, pickUpMinute) VALUES ('\(selected)', '\(rosterNameText)', '\(startDay)', '\(startMonth)', '\(startYear)', '\(endDay)', '\(endMonth)', '\(endYear)', '\(pickUpHour)', '\(pickUpMinute)')"
            }
            let result1 = database.update(insertSQL)
            if (result1 && result2 && result3) {
                self.back()
            } else if (!result1) {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Add Roster to Rosters Database")
                errorAlert.displayError()
            } else if (!result2) {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Update Roster in Sign Outs Database")
                errorAlert.displayError()
            } else if (!result3) {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Add Roster in Student Rosters Database")
                errorAlert.displayError()
            }
        } else {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Please give the Roster a Name")
            errorAlert.displayError()
        }
    }
    
    // Hide keyboard when done typing 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
