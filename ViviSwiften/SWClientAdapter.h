//
//  SWClientAdapter.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SWEventLoop.h"
#import "SWAccount.h"

/*!
 * @brief A Objective-C adapter for Swift::Client.
 * 
 * One Client correspond to one JID(or SWAccount). When connect method
 * called, the client will connect to server.
 *
 */
@interface SWClientAdapter : NSObject
- (id)init: (NSString*)account
  Password: (NSString*)passwd
 EventLoop: (SWEventLoop*)eventLoop;
- (void)dealloc;
- (NSString*)getAccount;

- (void)connect;
- (void)sendMessageTo: (SWAccount*)account
              Message: (NSString*)message;

@end
