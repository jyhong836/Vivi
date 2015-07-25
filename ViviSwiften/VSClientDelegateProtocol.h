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

// TODO: change method to @optional
//@optional
- (void)clientDidConnect: (SWClient*)client;
- (void)clientDidDisonnect: (SWClient*)client
              errorMessage: (NSString*)errString;
//@optional
- (void)clientDidReceiveMessage: (SWClient*)client
                    fromAccount: (SWAccount*)account
                      inContent: (NSString*)content;
- (void)clientDidReceivePresence: (SWClient*)client
                     fromAccount: (SWAccount*)account
                 currentPresence: (int)presenceType
                     currentShow: (int)show
                   currentStatus: (NSString*)status;

@end
