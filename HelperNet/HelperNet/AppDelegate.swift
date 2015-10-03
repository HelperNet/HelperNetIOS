//
//  AppDelegate.swift
//  HelperNet
//
//  Created by Alexander Immer on 03/10/15.
//  Copyright © 2015 nerdishByNature. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PPKControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
       PPKController.enableWithConfiguration("eyJzaWduYXR1cmUiOiJxM1AxT0NpZzlHNHNCZnVlamJqbThzVmlHMlVNb3QxeVNpNVFiM0U2NGJmNFRCVmIwZWJQTGtSUHh4eTMwdnBRbzBlOEVNYnhtQWNXbXdmT3VmWmxDWW0vMzRPbFJqOUljQ3lGVEVTOUduRGd1M2tPSTZHcWFXd1BwZEliMlY2WGtCTmRpS0JMT296Yk1Sb1haL3ZBYTdjbWpla0lNNlVlSWNMVWtvZVhrVmM9IiwiYXBwSWQiOjEyOTMsInZhbGlkVW50aWwiOjE2ODAwLCJhcHBVVVVJRCI6IjAzMzdCMjJCLTQ2RjEtNDc2Mi1BMkM5LTJENUZBODhDODRFQiJ9", observer: self)
        
        NSLog("Starting discovery.")
        let myStartDiscoveryInfo = "Hello HelperNet!".dataUsingEncoding(NSUTF8StringEncoding)
        PPKController.startP2PDiscoveryWithDiscoveryInfo(myStartDiscoveryInfo)

        NSLog("Pushing new discovery info.")
        let myNewDiscoveryInfo = "All ok!".dataUsingEncoding(NSUTF8StringEncoding)
        PPKController.pushNewP2PDiscoveryInfo(myNewDiscoveryInfo)
        
        return true
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

    // PKK stuff
    func PPKControllerInitialized() {
        PPKController.startP2PDiscovery()
        PPKController.startGeoDiscovery()
        PPKController.startOnlineMessaging()
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

