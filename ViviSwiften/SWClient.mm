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
#import "VSClientControllerProtocol.h"

#import <Swiften/Elements/Message.h>
#import <Swiften/Elements/Presence.h>
#import <Swiften/Network/BoostNetworkFactories.h>

using namespace Swift;
#import "SWClientAdapter.h"

@implementation SWClient {
    boost::shared_ptr<SWClientAdapter> client;
    ClientOptions options;
    NSString* passwd; // FIXME: the password should be encrypted
}

@synthesize managedObject;

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
    client->connect(options);
}

- (void)connectWithHandler: (VSConnectionHandler)handler
{
    connectHandler = handler;
    client->connect(options);
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
    swmsg->setBody(NSString2std_str(message));
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
    NSDate* timestamp = [NSDate date]; // FIXME: timestamp should be provided by Swiften
    id msgObject = [managedObject clientWillSendMessageTo: targetAccount
                                         message: message
                                       timestamp: timestamp];
    if (client->isAvailable()) {
        client->sendMessage(swmsg);
        [managedObject clientDidSendMessage: msgObject];
    } else {
        [managedObject clientFailSendMessage: msgObject
                                             error: VSClientErrorTypeClientUnavaliable];
    }
}

- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     Message: (NSString*)message
                     handler: (VSSendMessageHandler)handler
{
    Message::ref swmsg = [self createSwiftMessage: targetAccount
                                          Message: message];
    NSDate* timestamp = [NSDate date]; // FIXME: timestamp should be provided by Swiften
    id msgObject = [managedObject clientWillSendMessageTo: targetAccount
                                                               message: message
                                                             timestamp: timestamp];
    if (client->isAvailable()) {
        client->sendMessage(swmsg);
        [managedObject clientDidSendMessage: msgObject];
        handler(VSClientErrorTypeNone);
    } else {
        [managedObject clientFailSendMessage: msgObject
                                             error: VSClientErrorTypeClientUnavaliable];
        handler(VSClientErrorTypeClientUnavaliable);
    }
}

- (void)sendPresence: (int)presenceType
            showType: (int)showType
              status: (NSString*)status
{
    Presence::ref presence = Presence::create(NSString2std_str(status));
    presence->setType((Presence::Type)presenceType);
    presence->setShow((StatusShow::Type)showType);
    client->sendPresence(presence);
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
    client->setSoftwareVersion(NSString2std_str(name), NSString2std_str(version));
}

// MARK: ClientOptions
- (void)setManualHostname: (NSString*)manualHostname
{
    options.manualHostname = NSString2std_str(manualHostname);
}

- (void)setManualPort:(int)manualPort {
    options.manualPort = manualPort;
}

@end
