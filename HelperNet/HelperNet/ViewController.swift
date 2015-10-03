//
//  ViewController.swift
//  HelperNet
//
//  Created by Alexander Immer on 03/10/15.
//  Copyright © 2015 nerdishByNature. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PPKControllerDelegate {

    @IBAction func buttonCall(sender: AnyObject) {
        let myDiscoveryInfo = "EC: Epileptic Shock!".dataUsingEncoding(NSUTF8StringEncoding)
        PPKController.pushNewP2PDiscoveryInfo(myDiscoveryInfo)
        
        let settings = NSUserDefaults.standardUserDefaults()
        if (settings.boolForKey("callEmergencyOn")) {
            NSLog("call on")
            // todo: dispatch phone call
        }
        
        NSLog("Discovery Info changed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PPKController.addObserver(self)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func p2pPeerDiscovered(peer: PPKPeer!) {
        let discoveryInfoString = NSString(data: peer.discoveryInfo, encoding:NSUTF8StringEncoding)
        NSLog("%@ is here with discovery info: %@", peer.peerID, discoveryInfoString!)
    }
    
    func p2pPeerLost(peer: PPKPeer!) {
        NSLog("%@ is no longer here", peer.peerID)
    }
    
    func didUpdateP2PDiscoveryInfoForPeer(peer: PPKPeer!) {
        let discoveryInfo = NSString(data: peer.discoveryInfo, encoding: NSUTF8StringEncoding)
        NSLog("%@ has updated discovery info: %@", peer.peerID, discoveryInfo!)
    }

}

