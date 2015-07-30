//
//  VSChatListControllerProtocol.h
//  Vivi
//
//  Created by Junyuan Hong on 7/30/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

@class SWClient;
@class SWAccount;

@protocol VSChatListControllerProtocol

@required
- (void)clientDidSendMessage: (SWClient*)sender
                          to: (SWAccount*)receiver
                     message: (NSString*)message
                   timestamp: (NSDate*)date;
@required
- (void)clientDidReceivedMessage: (SWClient*)receiver
                            from: (SWAccount*)sender
                         message: (NSString*)message
                       timestamp: (NSDate*)date;

@end
