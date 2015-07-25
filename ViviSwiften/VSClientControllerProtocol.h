//
//  VIClientControllerProtocol.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSControllerProtocol.h"
#import "VSClientDelegateProtocol.h"
#import "SWClient.h"
#import "SWEventLoop.h"

@protocol VSClientController <NSObject, VSController>

@property (nonatomic) id<VSClientDelegate> clientDelegate;
@property (nonatomic) NSString* accountName;
@property (nonatomic) NSString* accountPasswd;
@property (nonatomic) SWClient* client;
@property (nonatomic) SWEventLoop* eventLoop;

- (void)connectWithHandler: (void(^)(BOOL))connectHandler;
- (void)connect;
// MARK: Implement in future
@optional
- (void)connectToAccount: (SWAccount*)account;
- (void)connectToAccount: (SWAccount*)account
             withHandler: (void(^)(BOOL))connectHandler;

@end
