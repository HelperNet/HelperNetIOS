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
    
    @IBAction func openP2PKitUrl(sender: AnyObject) {
        if let url = NSURL(string: "http://p2pkit.io") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func openFreepikUrl(sender: AnyObject) {
        if let url = NSURL(string: "http://www.freepik.com") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(emergencyCall.on, forKey: "callEmergencyOn")
        defaults.setObject(telNumber.text! as String, forKey: "phoneNumber")
        defaults.setObject(textMessage.text, forKey: "message")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let defaults = NSUserDefaults.standardUserDefaults()
        emergencyCall.on = defaults.boolForKey("callEmergencyOn")
        telNumber.text = defaults.objectForKey("phoneNumber") as? String ?? ""
        textMessage.text = defaults.objectForKey("message") as? String ?? "e.g. present illness and complaints, needed medication, other notes to doctors..."
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


