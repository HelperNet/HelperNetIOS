/**
 * PPKController.h
 * P2PKit
 *
 * Copyright (c) 2015 by Uepaa AG, Zürich, Switzerland.
 * All rights reserved.
 *
 * We reserve all rights in this document and in the information contained therein.
 * Reproduction, use, transmission, dissemination or disclosure of this document and/or
 * the information contained herein to third parties in part or in whole by any means
 * is strictly prohibited, unless prior written permission is obtained from Uepaa AG.
 *
 */

#import <Foundation/Foundation.h>
#import "PPKPeer.h"

#define P2PKIT_VERSION @"1.0.1"

/*!
 *  @enum PPKPeer2PeerDiscoveryState
 *
 *  @abstract Possible states of the P2P discovery engine.
 *
 */
typedef NS_ENUM(NSInteger, PPKPeer2PeerDiscoveryState) {
    
    /*! P2P discovery is disabled.*/
    PPKPeer2PeerDiscoveryStopped,
    
    /*! P2P discovery is temporarily suspended. The discovery engine will try to restart as soon as possible (e.g. after the user did re-enable BLE).*/
    PPKPeer2PeerDiscoverySuspended,
    
    /*! P2P discovery is running: the device will discover other peers and will be discovered by other peers.*/
    PPKPeer2PeerDiscoveryRunning
};

/*!
 *  @enum PPKGeoDiscoveryState
 *
 *  @abstract Possible states of the GEO discovery engine.
 *
 */
typedef NS_ENUM(NSInteger, PPKGeoDiscoveryState) {
    
    /*! GEO discovery is disabled.*/
    PPKGeoDiscoveryStopped,
    
    /*! GEO discovery is temporarily suspended. The discovery engine will try to restart periodically (e.g. after internet connectivity has been re-established).*/
    PPKGeoDiscoverySuspended,
    
    /*! GEO discovery is running: the device will discover other peers and will be discovered by other peers.*/
    PPKGeoDiscoveryRunning
};

/*!
 *  @enum PPKOnlineMessagingState
 *
 *  @abstract Possible states of the Online messaging engine.
 *
 */
typedef NS_ENUM(NSInteger, PPKOnlineMessagingState) {
    
    /*! Online messaging is disabled.*/
    PPKOnlineMessagingStopped,
    
    /*! Online messaging is temporarily suspended. The messaging engine will try to restart periodically (e.g. after internet connectivity has been re-established).*/
    PPKOnlineMessagingSuspended,
    
    /*! Online messaging is running: the device will be able to send and receive Online messages.*/
    PPKOnlineMessagingRunning
};

/*!
 *  @enum PPKErrorCode
 *
 *  @abstract P2PKit initialization error codes.
 *
 */
typedef NS_ENUM(NSInteger, PPKErrorCode) {
    
    /*! P22Kit initialization failed due to an invalid app configuration key. Please obtain a valid key.*/
    PPKErrorAppKeyInvalid,
    
    /*! P22Kit initialization failed due to an expired configuration key. Please obtain a new key.*/
    PPKErrorAppKeyExpired,
    
    /*! Server connection failed due to a server incompatibility. Please update to the most recent version of the framework.*/
    PPKErrorOnlineProtocolVersionNotSupported,
    
    /*! Server connection failed due to an invalid app configuration key. Please obtain a valid key.*/
    PPKErrorOnlineAppKeyInvalid,
    
    /*! Server connection failed due to an expired configuration key. Please obtain a new key.*/
    PPKErrorOnlineAppKeyExpired
};

#pragma mark - PPKControllerDelegate

/*!
 *  @protocol PPKControllerDelegate
 *
 *  @abstract Delivers lifecycle events, discovery events and messaging events
 *
 */
@protocol PPKControllerDelegate <NSObject>
@optional

#pragma mark Lifecycle

/*!
 *  @method PPKControllerInitialized
 *
 *  @abstract     Indicates successful initialization of the P2PKit. You must not call other methods before this delegate method has been called.
 */
-(void)PPKControllerInitialized;

/*!
 *  @method PPKControllerFailedWithError:
 *
 *  @abstract       Indicates an error with P2PKit (e.g. invalid configuration or server incompatibility due to an outdated version).
 *
 *  @param error    error containing the appropriate <code>PPKErrorCode</code>
 *
 *  @see            PPKErrorCode
 */
-(void)PPKControllerFailedWithError:(NSError*)error;

#pragma mark P2P Discovery

/*!
 *  @method p2pDiscoveryStateChanged:
 *
 *  @abstract       Indicates a state change of the P2P discovery engine (e.g. P2P discovery is temporarily suspended because the user disabled Bluetooth).
 *
 *  @param state    <code>PPKPeer2PeerDiscoveryState</code>
 *
 *  @see            PPKPeer2PeerDiscoveryState
 */
-(void)p2pDiscoveryStateChanged:(PPKPeer2PeerDiscoveryState)state;

/*!
 *  @method p2pPeerDiscovered:
 *
 *  @abstract       Reports P2P discovery of a nearby peer.
 *
 *  @param peer     peer with unique id and discovery info
 */
-(void)p2pPeerDiscovered:(PPKPeer*)peer;

/*!
 *  @method p2pPeerLost:
 *
 *  @abstract       Called if a recently discovered P2P-peer is no longer nearby. P2PKit tries to determine when a peer is no longer nearby on a best effort basis.
 *
 *  @param peer     peer with unique id and discovery info
 */
-(void)p2pPeerLost:(PPKPeer*)peer;

/*!
 *  @method didUpdateP2PDiscoveryInfoForPeer:
 *
 *  @abstract       Called if a discovered peer updated his discovery info.
 *
 *  @param peer     peer with unique id and discovery info
 */
-(void)didUpdateP2PDiscoveryInfoForPeer:(PPKPeer*)peer;

#pragma mark GEO Discovery

/*!
 *  @method geoDiscoveryStateChanged:
 *
 *  @abstract       Indicates a state change of the GEO discovery engine (e.g. GEO discovery is temporarily suspended due to lost internet connectivity).
 *
 *  @param state    <code>PPKGeoDiscoveryState</code>
 *
 *  @see            PPKGeoDiscoveryState
 */
-(void)geoDiscoveryStateChanged:(PPKGeoDiscoveryState)state;

/*!
 *  @method geoPeerDiscovered:
 *
 *  @abstract       Reports GEO discovery of a nearby peer (i.e. your reported GEO location is 'nearby' the reported GEO location of the peer).
 *
 *  @param peerID   unique id of the peer
 */
-(void)geoPeerDiscovered:(NSString*)peerID;

/*!
 *  @method geoPeerLost:
 *
 *  @abstract       Called if a recently discovered GEO-peer is no longer nearby. P2PKit tries to determine when a peer is no longer nearby on a best effort basis.
 *
 *  @param peerID   unique id of the peer
 */
-(void)geoPeerLost:(NSString*)peerID;

#pragma mark Online Messaging

/*!
 *  @method onlineMessagingStateChanged:
 *
 *  @abstract       Indicates a state change of the Online messaging engine (e.g. Online messaging is temporarily suspended due to lost internet connectivity).
 *
 *  @param state    <code>PPKOnlineMessagingState</code>
 *
 *  @see            PPKOnlineMessagingState
 */
-(void)onlineMessagingStateChanged:(PPKOnlineMessagingState)state;

/*!
 *  @method messageReceived:header:from:
 *
 *  @abstract               Called to deliver an Online message from a remote peer.
 *
 *  @param  messageBody     message body
 *  @param  messageHeader   type of the message body (e.g. @"text-message") - apps can freely choose header values
 *  @param  peerID          unique id of the remote peer
 */
-(void)messageReceived:(NSData*)messageBody header:(NSString*)messageHeader from:(NSString*)peerID;

@end

#pragma mark - PPKController

@class CLLocation;

/*!
 *  @class  PPKController
 *
 *  @abstract <code>PPKController</code> is your entry point to P2PKit. You will interact with P2PKit via static methods, never try to obtain an instance of <code>PPKController</code>.
 */
@interface PPKController : NSObject

#pragma mark Lifecycle

/*!
 *  @method enableWithConfiguration:observer
 *
 *  @abstract                   Initializes the P2PKit. Must be called first.
 *
 *  @param configurationString  your personal app configuration key
 *  @param observer             your (partial) implementation of the <code>PPKControllerDelegate</code> protocol
 *
 *  @warning                    This method must be called before any other interaction with <code>PPKController</code>
 *
 *  @see                        PPKControllerDelegate
 */
+(void)enableWithConfiguration:(NSString*)configurationString observer:(id<PPKControllerDelegate>)observer;

/*!
 * @method disable
 *
 * @abstract  Shuts-down the P2PKit.
 */
+(void)disable;

/*!
 *  @method myPeerID
 *
 *  @return the unique peer id of the current device. P2PKit generates this id when you enable <code>PPKController</code> for the first time.
 */
+(NSString*)myPeerID;

/*!
 *  @method addObserver:
 *
 *  @abstract       Registers an additional observer.
 *
 *  @param observer your (partial) implementation of the <code>PPKControllerDelegate</code> protocol
 *
 *  @see            PPKControllerDelegate
 */
+(void)addObserver:(id<PPKControllerDelegate>)observer;

/*!
 *  @method removeObserver:
 *
 *  @abstract       Removes an already registered observer.
 *
 *  @param observer registered observer
 */
+(void)removeObserver:(id<PPKControllerDelegate>)observer;

#pragma mark P2P Discovery

/*!
 *  @method     startP2PDiscovery
 *
 *  @abstract   Starts P2P discovery (after successful startup, you will discover nearby P2P peers and will be discovered by nearby P2P peers).
 */
+(void)startP2PDiscovery;

/*!
 *  @method     startP2PDiscoveryWithDiscoveryInfo:
 *
 *  @param info additional data you want to send when a peer is discovered (max. length: 440 bytes)
 *
 *  @abstract   Starts P2P discovery with discovery info (after successful startup, you will discover nearby P2P peers and will be discovered by nearby P2P peers).
 *
 *  @throws     NSException when the discovery info is too long
 */
+(void)startP2PDiscoveryWithDiscoveryInfo:(NSData*)info;

/*!
 *  @method     pushNewP2PDiscoveryInfo:
 *
 *  @param info additional data you want to send when a peer is discovered (max. length: 440 bytes)
 *
 *  @abstract   Updates the discovery info sent to other peers. The new discovery info is sent to other peers on a best effort basis and is not garantueed.
 *
 *  @throws     NSException when the discovery info is too long
 */
+(void)pushNewP2PDiscoveryInfo:(NSData*)info;

/*!
 *  @method stopP2PDiscovery
 *
 *  @abstract Stops P2P discovery (you will no longer discover P2P peers and will no longer be discovered by P2P peers).
 */
+(void)stopP2PDiscovery;

/*!
 *  @method p2pDiscoveryState
 *
 *  @return the current state of the P2P discovery engine
 *
 *  @see    PPKPeer2PeerDiscoveryState
 */
+(PPKPeer2PeerDiscoveryState)p2pDiscoveryState;

#pragma mark GEO Discovery

/*!
 *  @method startGeoDiscovery
 *
 *  @abstract   Starts GEO discovery (after successful startup, you will discover nearby GEO peers and will be discovered by nearby GEO peers). You should periodically report your current GEO location for GEO discovery to work. Use: <code>updateUserLocation:</code>.
 *
 *  @see        updateUserLocation:
 */
+(void)startGeoDiscovery;

/*!
 *  @method updateUserLocation:
 *
 *  @abstract           Informs the GEO discovery server about your most recent position. Should be called periodically.
 *
 *  @param  location    <code>CLLocation</code> your location
 */
+(void)updateUserLocation:(CLLocation*)location;

/*!
 *  @method stopGeoDiscovery
 *
 *  @abstract Stops GEO discovery (you will no longer discover GEO peers and will no longer be discovered by GEO peers).
 */
+(void)stopGeoDiscovery;

/*!
 *  @method geoDiscoveryState
 *
 *  @return the current state of the GEO discovery engine
 *
 *  @see    PPKGeoDiscoveryState
 */
+(PPKGeoDiscoveryState)geoDiscoveryState;

#pragma mark Online Messaging

/*!
 *  @method startOnlineMessaging
 *
 *  @abstract Starts Online messaging (after successful startup, you can send and receive Online messages).
 */
+(void)startOnlineMessaging;

/*!
 *  @method stopOnlineMessaging
 *
 *  @abstract Stops Online messaging (you will no longer be able to send or receive online messages).
 */
+(void)stopOnlineMessaging;

/*!
 *  @method sendMessage:withHeader:to
 *
 *  @abstract               Sends an Online message to a remote peer (best effort delivery semantics: fire and forget, at most once).
 *
 *  @param  messageBody     message body
 *  @param  messageHeader   type of the message body (e.g. @"text-message") - apps can freely choose header values
 *  @param  peerID          unique id of the remote peer
 */
+(void)sendMessage:(NSData*)messageBody withHeader:(NSString*)messageHeader to:(NSString*)peerID;

/*!
 *  @method onlineMessagingState
 *
 *  @return the current state of the Online messaging engine
 *
 *  @see    PPKOnlineMessagingState
 */
+(PPKOnlineMessagingState)onlineMessagingState;

@end
