//
//  AppDelegate.swift
//  HelperNet
//
//  Created by Alexander Immer on 03/10/15.
//  Copyright © 2015 nerdishByNature. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PPKControllerDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    var messagedLoc = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
    PPKController.enableWithConfiguration("eyJzaWduYXR1cmUiOiJieXBGVEtaR1NVNVAzWW56ZmlDMDZ5TnRnRDZTVGRLbWNGQTFpYlpWVllCWGVpUllIazEvbEVpcG8xZVJzMTlyaW5Mb1VFNU53c3ozSk5xNkpYT0hwUVQ0YSthc1RWbHNJM3ZPS3dsOGhSZ2dzNE9zb09FUGY1UmdHZU9raEkvZHoxUzdvWGN3bUxScW45dVAydkF5NWI4anZYZ2xHZ2paajZ6YVBuVTFmb2M9IiwiYXBwSWQiOjEyODgsInZhbGlkVW50aWwiOjE2ODAwLCJhcHBVVVVJRCI6IkQ3MkIxNUM0LThGRjMtNEVDRi04RjY4LUIwQzhBNjEwRkRFMSJ9", observer:self)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        // setup parameters for location services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = 0
        }
        
        NSLog("App started")
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if ( application.applicationState == UIApplicationState.Inactive || application.applicationState == UIApplicationState.Background )
        {
            let onTheWay = "OT".dataUsingEncoding(NSUTF8StringEncoding)
            PPKController.pushNewP2PDiscoveryInfo(onTheWay)
            NSLog("User wants to help")
        }
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        // set notification message set by user or default one
        let myDiscoveryInfo = getNotificationMessage().dataUsingEncoding(NSUTF8StringEncoding)
        PPKController.pushNewP2PDiscoveryInfo(myDiscoveryInfo)
        
        // start location service
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        messagedLoc = false
        
        // dispatch emergency call when allowed in settings
        let settings = NSUserDefaults.standardUserDefaults()
        if settings.boolForKey("callEmergencyOn") {
            let phoneNumber = settings.objectForKey("phoneNumber") as? String ?? "+491736353009"
            let phoneUrlString = "tel://\(phoneNumber)"
            let url: NSURL = NSURL(string: phoneUrlString)!
            UIApplication.sharedApplication().openURL(url)
        }
        return true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !messagedLoc {
            messagedLoc = true
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
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func PPKControllerInitialized() {
        let myDiscoveryInfo = "OK".dataUsingEncoding(NSUTF8StringEncoding)
        PPKController.startP2PDiscoveryWithDiscoveryInfo(myDiscoveryInfo)
        NSLog("PPK Controller Initialized")
    }
        
    func getNotificationMessage() -> String {
        // from settings get the notification message
        let defaults = NSUserDefaults.standardUserDefaults()
        let message = defaults.objectForKey("message") as? String ?? "Default Emergency Call!"
        return message
    }
    
    func requestNotification(info: NSString!) {
        // dispatch on DiscoveryInfo
        if info.hasPrefix("OK") || info.hasPrefix("OT") {
            // "OT" covered in ViewController, "OK" remains silent
        }
        else if info.hasPrefix("LO") {
            var infoStr = info as String
            let range = infoStr.startIndex..<infoStr.startIndex.advancedBy(3)
            infoStr.removeRange(range)
            UIApplication.sharedApplication().openURL(NSURL(string: ("http://maps.apple.com/?ll=" + infoStr))!)
        }
        else {
            let localNotification = UILocalNotification()
            localNotification.alertAction = "Emergency"
            localNotification.alertBody = self.getNotificationMessage()
            UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
        }
    }
    
    func p2pPeerDiscovered(peer: PPKPeer!) {
        let discoveryInfoString = NSString(data: peer.discoveryInfo, encoding:NSUTF8StringEncoding)
        NSLog("%@: %@", peer.peerID, discoveryInfoString!)
        
        self.requestNotification(discoveryInfoString)
    }
    
    func p2pPeerLost(peer: PPKPeer!) {
        NSLog("%@ is no longer here", peer.peerID)
    }
    
    func didUpdateP2PDiscoveryInfoForPeer(peer: PPKPeer!) {
        let discoveryInfo = NSString(data: peer.discoveryInfo, encoding: NSUTF8StringEncoding)
        NSLog("%@ has updated discovery info: %@", peer.peerID, discoveryInfo!)

        self.requestNotification(discoveryInfo)
    }
    
}

