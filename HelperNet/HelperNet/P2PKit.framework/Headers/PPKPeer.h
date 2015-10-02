/**
 * PPKPeer.h
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

@interface PPKPeer : NSObject

@property (readonly) NSString *peerID;
@property (readonly) NSData *discoveryInfo;

@end
