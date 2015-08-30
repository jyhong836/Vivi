//
//  SWClient.m
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

//#define __XML_TRACER__

#define __INVISIBLE__
#ifdef __INVISIBLE__
    #define __INVISIBLE_PRESENCE__ // XEP-0018(rejected)
    //#define __INVISIBLE_INVISIBILITY__ // XEP-0126
#endif // __INVISIBLE__

#import "SWClient.h"
#import "SWEventLoop.h"
#import "SWAccount.h"
#import "SWXMPPRoster.h"
#import "VSClientControllerProtocol.h"

#ifdef __INVISIBLE_INVISIBILITY__
    #import "InvisibleListPayload.hpp"
    #import "InvisibleListPayloadSerializer.hpp"
    #import "InvisibleActivePayload.hpp"
    #import "InvisibleActiveSerializer.hpp"
#endif // __INVISIBLE_INVISIBILITY__

#ifdef __XML_TRACER__
    #import <Swiften/Client/ClientXMLTracer.h>
#endif // __XML_TRACER__
#import <Swiften/Elements/Message.h>
#import <Swiften/Network/BoostNetworkFactories.h>
#import <Swiften/Queries/Requests/SetPrivateStorageRequest.h>
#import <Swiften/Serializer/PayloadSerializerCollection.h>

#import <Swiften/Elements/Presence.h>
#ifdef __INVISIBLE_PRESENCE__
#ifndef SWIFTEN_INVISIBLE_PRESENCE
#warning Attempt to use invisible presence, while it's not implemented in Swiften.
#undef __INVISIBLE_PRESENCE__
#endif // SWIFTEN_INVISIBLE_PRESENCE
#endif // __INVISIBLE_PRESENCE__

using namespace Swift;
#import "SWClientAdapter.h"

@implementation SWClient {
    boost::shared_ptr<SWClientAdapter> client;
    ClientOptions options;
    NSString* passwd;
#ifdef __INVISIBLE_INVISIBILITY__
    InvisibleListPayloadSerializer invisibleListPayloadSerializer;
    InvisibleActiveSerializer invisibleActiveSerializer;
    BOOL hasInitInvisibleList;
    BOOL hasInitVisibleList;
#endif // __INVISIBLE_INVISIBILITY__
    
#ifdef __XML_TRACER__
    ClientXMLTracer *tracer;
#endif // __XML_TRACER__
}

@synthesize managedObject;

@synthesize account;
@synthesize roster;
@synthesize priority;

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
        priority = 0;
#ifdef __INVISIBLE_INVISIBILITY__
        client->addPayloadSerializer(&invisibleListPayloadSerializer);
        client->addPayloadSerializer(&invisibleActiveSerializer);
#endif // __INVISIBLE_INVISIBILITY__
        
        _invisible = NO;
        
#ifdef __XML_TRACER__
        tracer = new ClientXMLTracer(&*client);
#endif // __XML_TRACER__
    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"delete SWClient %@", [account getAccountString]);
//    if (client->isActive()) {
//        client->disconnect();
    //    }
#ifdef __INVISIBLE_INVISIBILITY__
    client->removePayloadSerializer(&invisibleListPayloadSerializer);
    client->removePayloadSerializer(&invisibleActiveSerializer);
#endif // __INVISIBLE_INVISIBILITY__
    
#ifdef __XML_TRACER__
    delete tracer;
#endif // __XML_TRACER__
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
            priority: (int)aPriority
{
    Presence::ref presence = Presence::create(NSString2std_str(status));
    presence->setType((Presence::Type)presenceType);
    presence->setShow((StatusShow::Type)showType);
    presence->setPriority(aPriority);
    client->sendPresence(presence);
}

- (void)sendPresence: (int)presenceType
            showType: (int)showType
              status: (NSString*)status
{
    [self sendPresence: presenceType showType:showType status:status priority: priority];
}

#pragma mark Implement invisible presence(XEP-0018 or XEP-0126).

#ifdef __INVISIBLE_INVISIBILITY__
/// Send visible or invisible list set request to sever, according to (BOOL)invisible property. (XEP-0126)
- (void)initInvisibleList
{
    SetPrivateStorageRequest<InvisibleListPayload>::ref request = SetPrivateStorageRequest<InvisibleListPayload>::create(boost::shared_ptr<InvisibleListPayload>(new InvisibleListPayload(_invisible)), client->getIQRouter());
    request->send();
    // TODO: handler the error
    if (_invisible) {
        hasInitInvisibleList = YES;
    } else {
        hasInitVisibleList = YES;
    }
}
#endif // __INVISIBLE_INVISIBILITY__

- (void)setInvisible: (BOOL)invisible
{
    if (invisible != _invisible) {
        _invisible = invisible;
#ifndef __INVISIBLE__
        [NSException raise:@"InvisibleNotImplemented" format:@"Invisible presence is not implemented"];
#endif // ~__INVISIBLE__
#ifdef __INVISIBLE_INVISIBILITY__
        if (invisible) {
            if (!hasInitInvisibleList) {
                [self initInvisibleList];
            }
        } else {
            if (!hasInitVisibleList) {
                [self initInvisibleList];
            }
        }
        SetPrivateStorageRequest<InvisibleActivePayload>::ref request = SetPrivateStorageRequest<InvisibleActivePayload>::create(boost::shared_ptr<InvisibleActivePayload>(new InvisibleActivePayload(_invisible)), client->getIQRouter());
        request->send();
#endif // __INVISIBLE_INVISIBILITY__
#ifdef __INVISIBLE_PRESENCE__
        if (invisible) {
            Presence::ref presence = Presence::create();
            presence->setType(Presence::Type::Unavailable);
            client->sendPresence(presence);
        }
#endif // __INVISIBLE_INVISIBILITY__
    }
}

- (BOOL)canBeInvisible
{
    if (client->serverHasFeature("presence")) {
#ifndef __INVISIBLE__
        return NO;
#else
    #ifdef __INVISIBLE_PRESENCE__
            return YES;
    #else
        #ifdef __INVISIBLE_INVISIBILITY__
                return YES;
        #else
                return NO;
        #endif
    #endif
#endif
    } else {
        return NO;
    }
}

@synthesize updateServerCapsHandler;
@synthesize hasInitializedServerCaps;

- (BOOL)hasInitializedServerCaps
{
    return client->hasInitializedServerDiscoInfo();
}

- (void)updateServerCapsWithHandler: (VSUpdateServerCapsHandler)handler
{
    updateServerCapsHandler = handler;
    client->requestServerDiscoInfo();
}

- (void)setUpdateServerCapsHandlerToNil
{
    updateServerCapsHandler = nil;
}

#pragma mark Client status

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

#pragma mark ClientOptions

- (void)setManualHostname: (NSString*)manualHostname
{
    options.manualHostname = NSString2std_str(manualHostname);
}

- (void)setManualPort:(int)manualPort {
    options.manualPort = manualPort;
}

@end
