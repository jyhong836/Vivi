//
//  SWClientAdapter.m
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWClientAdapter.h"
#include <Swiften/Swiften.h>
using namespace Swift;
#import "SWClientSlots.h"

@implementation SWClientAdapter {
    SWClientSlots *client;
    SWAccount* account;// FIXME: memory control for NSString
    NSString* passwd; // FIXME: the password should be encrypted
}

- (id)init: (NSString*)aAccount
  Password: (NSString*)aPasswd
 EventLoop: (SWEventLoop*)eventLoop
{
    if (self = [super init]) {
        if (aAccount && aPasswd) {
            account = [[SWAccount alloc] init: aAccount];
            passwd = aPasswd;
            client = new SWClientSlots(
                              *account.jid,
                                       [passwd cStringUsingEncoding:NSASCIIStringEncoding],
                                       [eventLoop getNetworkFactories],
                                       self);
        } else {
            // TODO: add alert for NULL account or password
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{
    delete client;
}

- (SWAccount*)getAccount
{
    return account;
}

// MARK: Wrap the method of Swift::Client
/*!
 * @brief Connect the client account to server.
 */
- (void)connect
{
    client->connect();
}

/*!
 * @brief Send message to specific account.
 */
- (void)sendMessageTo: (SWAccount*)targetAccount
              Message: (NSString*)message
{
    Message::ref swmsg;
    swmsg->setFrom(*account.jid);
    swmsg->setTo(*targetAccount.jid);
    swmsg->setBody([message cStringUsingEncoding:NSASCIIStringEncoding]);
    client->sendMessage(swmsg);
}

@end
