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
#import "SWXMPPRoster.h"
#import "VSChatListControllerProtocol.h"
#include <Swiften/Swiften.h>
using namespace Swift;
#import "SWClientAdapter.h"

@implementation SWClient {
    boost::shared_ptr<SWClientAdapter> client;
//    SWAccount* account;// FIXME: memory control for NSString
    NSString* passwd; // FIXME: the password should be encrypted
}

@synthesize account;
@synthesize roster;

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
        roster = [[SWXMPPRoster alloc] init: client->getRoster()];
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

- (void)connectWithHandler: (VSConnectionHandler)handler
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

- (void)disconnectWithHandler: (VSConnectionHandler)handler
{
    client->disconnect();
    disconnectHandler = handler;
}

- (Message::ref)createSwiftMessage: (SWAccount*)targetAccount
                           Message: (NSString*)message
{
    // FIXME: Is this a right usage of boost::shared_ptr?
    Message::ref swmsg = boost::make_shared<Message>();
    swmsg->setFrom(*account.jid);
    swmsg->setTo(*targetAccount.jid);
    swmsg->setBody([message cStringUsingEncoding:NSASCIIStringEncoding]);
    return swmsg;
}

/*!
 * @brief Send message to specific account.
 */
- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     Message: (NSString*)message
{
    Message::ref swmsg = [self createSwiftMessage: targetAccount
                                          Message: message];
    [_chatListController clientWillSendMessageTo: targetAccount
                                         message: message
                                       timestamp: [NSDate date]];
    if (client->isAvailable()) {
        client->sendMessage(swmsg);
        [_chatListController clientDidSendMessageTo: targetAccount
                                             message: message
                                           timestamp: [NSDate date]];
    } else {
        [_chatListController clientFailSendMessageTo: targetAccount
                                             message: message
                                           timestamp: [NSDate date]
                                               error: VSClientErrorTypeClientUnavaliable];
    }
}

- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     Message: (NSString*)message
                     handler: (VSSendMessageHandler)handler
{
    Message::ref swmsg = [self createSwiftMessage: targetAccount
                                          Message: message];
    [_chatListController clientWillSendMessageTo: targetAccount
                                         message: message
                                       timestamp: [NSDate date]];
    if (client->isAvailable()) {
        client->sendMessage(swmsg);
        [_chatListController clientDidSendMessageTo: targetAccount
                                            message: message
                                          timestamp: [NSDate date]];
        handler(VSClientErrorTypeNone);
    } else {
        [_chatListController clientFailSendMessageTo: targetAccount
                                             message: message
                                           timestamp: [NSDate date]
                                               error: VSClientErrorTypeClientUnavaliable];
        handler(VSClientErrorTypeClientUnavaliable);
    }
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
