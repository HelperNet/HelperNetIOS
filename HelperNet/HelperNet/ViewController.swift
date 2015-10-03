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
    var peopleCounter = 0
    
    @IBOutlet weak var peopleNearby: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func buttonCall(sender: AnyObject) {
        emergencyCall()
        imageView.image = UIImage(named: "emergency")
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    func dispatchCall(fullMessage: String) {
        NSLog("Pushing full message -- "+fullMessage)
        
        // push to p2p
        PPKController.pushNewP2PDiscoveryInfo(fullMessage.dataUsingEncoding(NSUTF8StringEncoding))
        
        // dispatch emergency call when allowed in settings
        let settings = NSUserDefaults.standardUserDefaults()
        if settings.boolForKey("callEmergencyOn") {
            let phoneNumber = settings.objectForKey("phoneNumber") as? String ?? "+491736353009"
            let phoneUrlString = "tel://\(phoneNumber)"
            let url: NSURL = NSURL(string: phoneUrlString)!
            UIApplication.sharedApplication().openURL(url)
        }
        
        appDelegate?.messagedLoc = false
    }
    
    func emergencyCall() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            dispatchCall(getNotificationMessage())
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !appDelegate!.messagedLoc  {
            appDelegate?.messagedLoc = true
            
            let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
            let lat = "\(locValue.latitude)"
            let lng = "\(locValue.longitude)"
            let locationMessage = ("LO" + lat + "," + lng)
            NSLog("Build Message -- LO " + lat + "," + lng)
            
            dispatchCall(getNotificationMessage()+"|"+locationMessage)
            
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

    func getNotificationMessage() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        let message = defaults.objectForKey("message") as? String ?? "Default Emergency Call!"
        
        let notificationMessage = "NO"+message
        NSLog("Build Message -- "+notificationMessage)
        
        return notificationMessage
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func updatePeopleNearby() {
        if (peopleCounter == 1) {
            peopleNearby.text = String(peopleCounter) + " person nearby"
        } else {
            peopleNearby.text = String(peopleCounter) + " persons nearby"
        }
    }
    
    //=== P2PKIT DELEGATE
    
    func p2pPeerDiscovered(peer: PPKPeer!) {
        peopleCounter += 1
        updatePeopleNearby()
    }
    
    func p2pPeerLost(peer: PPKPeer!) {
        peopleCounter -= 1
        if (peopleCounter < 0) {
            peopleCounter = 0
        }
        
        updatePeopleNearby()
    }
}

