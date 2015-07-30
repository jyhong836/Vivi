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
    boost::shared_ptr<SWClientAdapter> client;
//    SWAccount* account;// FIXME: memory control for NSString
    NSString* passwd; // FIXME: the password should be encrypted
}

@synthesize account;
@synthesize connectHandler;
- (void)setConnectHandlerToNil
{
    connectHandler = nil;
}
@synthesize disconnectHandler;
- (void)setDisconnectHandlerToNil
{
    disconnectHandler = nil;
}

- (id)initWithAccount: (SWAccount*)aAccount
             password: (NSString*)aPasswd
            eventLoop: (SWEventLoop*)aEventLoop
{
    if (self = [super init]) {
        account = aAccount;
        passwd = aPasswd;
        client = boost::make_shared<SWClientAdapter>(
                                                     account,
                                                     NSString2std_str(passwd),
                                                     [aEventLoop getNetworkFactories],
                                                     self);
        connectHandler = nil;
    }
    return self;
}

//- (void)dealloc
//{
//    NSLog(@"delete SWClient %@", [account getAccountString]);
//    if (client->isActive()) {
//        client->disconnect();
//    }
//}

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

- (void)connectWithHandler: (ConnectionHandler)handler
{
    connectHandler = handler;
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

- (void)disconnectWithHandler: (ConnectionHandler)handler
{
    client->disconnect();
    disconnectHandler = handler;
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
