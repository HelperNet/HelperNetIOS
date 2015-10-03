//
//  EmergencyViewController.swift
//  HelperNet
//
//  Created by Alexander Immer on 03/10/15.
//  Copyright © 2015 nerdishByNature. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController, PPKControllerDelegate {
    
    @IBOutlet weak var helperNumberLabel: UILabel!
    var helperNumber = 0
    
    @IBOutlet weak var imageView: UIImageView!
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
            helperNumberLabel.text = String(helperNumber)
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

