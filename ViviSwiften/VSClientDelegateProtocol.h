//
//  fuck.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

@class SWClient;
@class SWAccount;

@protocol VSClientDelegate <NSObject>

@optional
- (void)clientDidConnect: (SWClient*)client;
@optional
- (void)clientDidDisconnect: (SWClient*)client
                  errorCode: (int)code;
@optional
- (void)clientDidReceiveMessage: (SWClient*)client
                    fromAccount: (SWAccount*)account
                      inContent: (NSString*)content;
@optional
- (void)clientDidReceivePresence: (SWClient*)client
                     fromAccount: (SWAccount*)account
                 currentPresence: (int)presenceType
                     currentShow: (int)show
                   currentStatus: (NSString*)status;

@end
