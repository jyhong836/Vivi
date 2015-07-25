//
//  VIClientControllerProtocol.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

@class SWClient;
@class SWAccount;
@class SWEventLoop;
@protocol VSController;

@protocol VSClientManager <NSObject, VSController>

@property (readonly, nonatomic) NSArray<SWClient*>* clientList;
// FIXME: eventloop should be managed by ClientManager?
@property (readonly, nonatomic) SWEventLoop* eventLoop;

- (void)addClient: (SWClient*)client;
- (void)addClientWithAccount: (SWAccount*)account;
- (void)addClientWithAccountName: (NSString*)account
                       andPasswd: (NSString*)passwd;

@end
