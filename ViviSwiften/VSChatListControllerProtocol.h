//
//  VSChatListControllerProtocol.h
//  Vivi
//
//  Created by Junyuan Hong on 7/30/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "ViviSwiftenDefines.h"

@class SWClient;
@class SWAccount;

@protocol VSChatListControllerProtocol

@property (readonly, nonatomic) SWAccount* owner;

@required
- (void)clientWillSendMessageTo: (SWAccount*)receiver
                        message: (NSString*)message
                      timestamp: (NSDate*)date;
@required
- (void)clientDidSendMessageTo: (SWAccount*)receiver
                       message: (NSString*)message
                     timestamp: (NSDate*)date;
@required
- (void)clientFailSendMessageTo: (SWAccount*)receiver
                        message: (NSString*)message
                      timestamp: (NSDate*)date
                          error: (VSClientErrorType)error;
@required
- (void)clientDidReceivedMessageFrom: (SWAccount*)sender
                             message: (NSString*)message
                           timestamp: (NSDate*)date;

@end
