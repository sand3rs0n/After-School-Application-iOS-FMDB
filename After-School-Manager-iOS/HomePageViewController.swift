/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        image.image = UIImage(named:"img/logo.png")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnHomeUnwind(segue: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "HomePageToSignOutRosterSelect") {
            let rlvc = segue.destinationViewController as? RosterListViewController
            rlvc?.setState(1)
            rlvc?.setTitleValue("Select Roster")
        } else if (segue.identifier == "HomePageToStudentRoster") {
            let srvc = segue.destinationViewController as? StudentRosterViewController
            srvc?.setTitleValue("Student Roster")
        }
    }
}
