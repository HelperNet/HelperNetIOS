//
//  ViewController.swift
//  HelperNet
//
//  Created by Alexander Immer on 03/10/15.
//  Copyright © 2015 nerdishByNature. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PPKControllerDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!

    @IBAction func buttonCall(sender: AnyObject) {
        let myDiscoveryInfo = "Hello from Swift!".dataUsingEncoding(NSUTF8StringEncoding)
        PPKController.startP2PDiscoveryWithDiscoveryInfo(myDiscoveryInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func p2pPeerDiscovered(peer: PPKPeer!) {
        let text = self.messageLabel.text
        self.messageLabel.text = text! + " another input "
    }
    
    func p2pPeerLost(peer: PPKPeer!) {
        self.messageLabel.text = "peer no longer here"
    }


}

