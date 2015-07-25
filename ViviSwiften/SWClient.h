//
//  SWClient.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SWEventLoop.h"
#import "SWAccount.h"

@protocol VSClientDelegate;

/*!
 * @brief A Objective-C adapter for Swift::Client.
 * 
 * One Client correspond to one JID(or SWAccount). When connect method
 * called, the client will connect to server.
 *
 */
@interface SWClient : NSObject
@property (nonatomic) BOOL isConnected;

@property (readonly, nonatomic) id<VSClientDelegate> delegate;

- (id)init: (NSString*)account
  Password: (NSString*)passwd
 EventLoop: (SWEventLoop*)eventLoop;
- (void)dealloc;
- (SWAccount*)getAccount;

- (void)connect;
- (void)disconnect;
- (void)sendMessageToAccount: (SWAccount*)account
              Message: (NSString*)message;

- (BOOL)isAvailable;
- (BOOL)isActive;

- (void)setSoftwareName: (NSString*)name
         currentVersion: (NSString*)version
              currentOS: (NSString*)os;
- (void)setSoftwareName: (NSString*)name
         currentVersion: (NSString*)version;

@end
