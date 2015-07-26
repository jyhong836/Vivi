//
//  SWClient.m
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWClient.h"
#import "SWEventLoop.h"
#import "SWAccount.h"
#include <Swiften/Swiften.h>
using namespace Swift;
#import "SWClientAdapter.h"

@implementation SWClient {
    SWClientAdapter *client;
//    SWAccount* account;// FIXME: memory control for NSString
    NSString* passwd; // FIXME: the password should be encrypted
}

@synthesize account;
@synthesize isConnected;

- (id)initWithAccount: (SWAccount*)aAccount
  Password: (NSString*)aPasswd
 EventLoop: (SWEventLoop*)eventLoop
{
    if (self = [super init]) {
        isConnected = NO;
        client = new SWClientAdapter(aAccount,
                                     NSString2std_str(aPasswd),
                                     [eventLoop getNetworkFactories],
                                     self);
    }
    return self;
}

- (id)initWithAccountString: (NSString*)aAccountString
  Password: (NSString*)aPasswd
 EventLoop: (SWEventLoop*)eventLoop
{
    if (self = [super init]) {
        isConnected = NO;
        if (aAccountString && aPasswd) {
            account = [[SWAccount alloc] init: aAccountString];
            passwd = aPasswd;
            client = new SWClientAdapter(
                                         account,
                                         NSString2std_str(passwd),
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
 * @brief Connect the client account to the server.
 */
- (void)connect
{
    client->connect();
}
/*!
 * @brief Disconnect the client account from the server.
 */
- (void)disconnect
{
    // FIXME: Sometime will assert at BasicSessionStream::writeFooter()
    client->disconnect();
}

/*!
 * @brief Send message to specific account.
 */
- (void)sendMessageToAccount: (SWAccount*)targetAccount
              Message: (NSString*)message
{
    // FIXME: Is this a right usage of boost::shared_ptr?
    Message::ref swmsg = boost::make_shared<Message>();
    swmsg->setFrom(*account.jid);
    swmsg->setTo(*targetAccount.jid);
    swmsg->setBody([message cStringUsingEncoding:NSASCIIStringEncoding]);
    client->sendMessage(swmsg);
}

- (BOOL)isAvailable
{
    return client->isAvailable();
}

- (BOOL)isActive
{
    return client->isActive();
}

- (void)setSoftwareName: (NSString*)name
         currentVersion: (NSString*)version
              currentOS: (NSString*)os
{
    NSString2std_str(name);
    client->setSoftwareVersion(NSString2std_str(name), NSString2std_str(version), NSString2std_str(os));
}

- (void)setSoftwareName: (NSString*)name
         currentVersion: (NSString*)version
{
    NSString2std_str(name);
    client->setSoftwareVersion(NSString2std_str(name), NSString2std_str(version));
}

@end
