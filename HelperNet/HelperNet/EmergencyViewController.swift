//
//  EmergencyViewController.swift
//  HelperNet
//
//  Created by Alexander Immer on 03/10/15.
//  Copyright © 2015 nerdishByNature. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController, PPKControllerDelegate {
    
    var helperNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PPKController.addObserver(self)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        helperNumber = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestNotification(info: NSString!) {
        if info.hasPrefix("OT") {
            helperNumber += 1
        }
    }
    
    func p2pPeerDiscovered(peer: PPKPeer!) {
        let discoveryInfoString = NSString(data: peer.discoveryInfo, encoding:NSUTF8StringEncoding)
        self.requestNotification(discoveryInfoString)
    }
    
    func didUpdateP2PDiscoveryInfoForPeer(peer: PPKPeer!) {
        let discoveryInfo = NSString(data: peer.discoveryInfo, encoding: NSUTF8StringEncoding)
        self.requestNotification(discoveryInfo)
    }

    
}
