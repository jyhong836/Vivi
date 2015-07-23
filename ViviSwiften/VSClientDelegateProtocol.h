//
//  fuck.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "SWClientAdapter.h"

@class SWAccount;

@protocol VSClientDelegate <NSObject>

// TODO: change method to @optional
//@optional
- (void)clientDidConnect: (SWClientAdapter*)client;
- (void)clientDidDisonnect: (SWClientAdapter*)client
              errorMessage: (NSString*)errString;
//@optional
- (void)clientDidReceiveMessage: (SWClientAdapter*)client
                    fromAccount: (SWAccount*)account
                      inContent: (NSString*)content;
- (void)clientDidReceivePresence: (SWClientAdapter*)client
                     fromAccount: (SWAccount*)account
                 currentPresence: (int)presenceType
                     currentShow: (int)show
                   currentStatus: (NSString*)status;

@end
