//
//  TableViewController.swift
//  HelperNet
//
//  Created by Alexander Immer on 03/10/15.
//  Copyright © 2015 nerdishByNature. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var telNumber: UITextField!
    
    @IBOutlet weak var emergencyCall: UISwitch!
    
    @IBOutlet weak var textMessage: UITextView!
    
    override func viewWillDisappear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(telNumber.text! as String, forKey: "phoneNumber")
        defaults.setBool(emergencyCall.on, forKey: "callEmergencyOn")
        defaults.setObject(textMessage.text, forKey: "message")
        print("Settings will disappear")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let defaults = NSUserDefaults.standardUserDefaults()
        telNumber.text = defaults.objectForKey("phoneNumber") as? String ?? ""
        emergencyCall.on = defaults.boolForKey("callEmergencyOn")
        textMessage.text = defaults.objectForKey("message") as? String ?? "Default Emergency Message!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


