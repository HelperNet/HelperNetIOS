//
//  EmergencyViewController.swift
//  HelperNet
//
//  Created by Alexander Immer on 03/10/15.
//  Copyright © 2015 nerdishByNature. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController, PPKControllerDelegate {
    
    @IBOutlet weak var helperNumberLabelPerson: UILabel!
    @IBOutlet weak var helperNumberLabel: UILabel!
    var helperNumber = 0
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        PPKController.addObserver(self)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
            helperNumberLabel.text = String(helperNumber)
            
            if (helperNumber == 1) {
                helperNumberLabelPerson.text = "person has responded"
            } else {
                helperNumberLabelPerson.text = "persons have responded"
            }
        }
    }
    
    func p2pPeerDiscovered(peer: PPKPeer!) {
        NSLog("peer discovered -- emergency view")
        if let discoveryInfoString = NSString(data: peer.discoveryInfo, encoding: NSUTF8StringEncoding) {
            self.requestNotification(discoveryInfoString)
        }
    }
    
    func didUpdateP2PDiscoveryInfoForPeer(peer: PPKPeer!) {
        NSLog("peer updated -- emergency view")
        if let discoveryInfo = NSString(data: peer.discoveryInfo, encoding: NSUTF8StringEncoding) {
            self.requestNotification(discoveryInfo)
        }
    }
    
    func p2pPeerLost(peer: PPKPeer!) {
        if peer != nil {
            NSLog("%@ is no longer here", peer.peerID)
        }
    }
    
    @IBAction func abortButtonPressed(sender: AnyObject) {
        imageView.image = UIImage(named:"abort")
    }
    @IBAction func abortButtonTouched(sender: AnyObject) {
        imageView.image = UIImage(named:"abort_pressed")
    }
    @IBAction func abortButtonReleased(sender: AnyObject) {
        imageView.image = UIImage(named:"abort")
    }
}

