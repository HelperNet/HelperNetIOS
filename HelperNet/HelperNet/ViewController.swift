//
//  ViewController.swift
//  HelperNet
//
//  Created by Alexander Immer on 03/10/15.
//  Copyright © 2015 nerdishByNature. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, PPKControllerDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func buttonCall(sender: AnyObject) {
        emergencyCall()
        imageView.image = UIImage(named: "emergency")
    }
    
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        //        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func emergencyCall() {
        // discover peers
        let myDiscoveryInfo = getNotificationMessage().dataUsingEncoding(NSUTF8StringEncoding)
        PPKController.pushNewP2PDiscoveryInfo(myDiscoveryInfo)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        appDelegate?.messagedLoc = false
        
        // dispatch emergency call when allowed in settings
        let settings = NSUserDefaults.standardUserDefaults()
        if settings.boolForKey("callEmergencyOn") {
            let phoneNumber = settings.objectForKey("phoneNumber") as? String ?? "+491736353009"
            let phoneUrlString = "tel://\(phoneNumber)"
            let url: NSURL = NSURL(string: phoneUrlString)!
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        PPKController.addObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "triggerMySegue:", name: "segueListener", object: nil)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func triggerMySegue(notification: NSNotification) {
        performSegueWithIdentifier("SegueToEmergency", sender: self)
        emergencyCall()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !appDelegate!.messagedLoc  {
            appDelegate?.messagedLoc = true
            let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
            let lat = "\(locValue.latitude)"
            let lng = "\(locValue.longitude)"
            let myDiscoveryInfo = ("LO:" + lat + "," + lng).dataUsingEncoding(NSUTF8StringEncoding)
            PPKController.pushNewP2PDiscoveryInfo(myDiscoveryInfo)
            NSLog("LO: " + lat + "," + lng)
            if CLLocationManager.locationServicesEnabled() {
                locationManager.stopUpdatingLocation()
            }
        }
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
    
    func getNotificationMessage() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        let message = defaults.objectForKey("message") as? String ?? "Default Emergency Call!"
        return message
    }

    @IBAction func emergencyButtonTouched(sender: AnyObject) {
        imageView.image = UIImage(named: "emergency_pressed")
    }
    
    
    @IBAction func emergencyButtonReleased(sender: AnyObject) {
        imageView.image = UIImage(named: "emergency")
    }
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("SegueToSettings", sender: self)
    }
    
    
}

