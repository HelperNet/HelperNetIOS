//
//  TableViewController.swift
//  HelperNet
//
//  Created by Alexander Immer on 03/10/15.
//  Copyright © 2015 nerdishByNature. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var callEmergency: UISwitch!
    
    @IBOutlet weak var updateEmergencyText: UITextView!
    
    override func viewWillDisappear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(phoneNumber.text, forKey: "phoneNumber")
        defaults.setObject(callEmergency.on, forKey: "callEmergencyOn")
        defaults.setObject(updateEmergencyText.text, forKey: "message")
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


