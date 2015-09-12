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
#import "SWFileTransferManager.h"
#import "SWCertificateTrustChecker.h"

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
#import <Swiften/Disco/ClientDiscoManager.h>
#import <Swiften/Client/NickManagerImpl.h>
#import <Swiften/FileTransfer/FileTransferManager.h>

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
    SWCertificateTrustChecker* certificateChecker;
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

#pragma mark - Properties

@synthesize managedObject;

@synthesize account;
@synthesize roster;
@synthesize priority;
@synthesize nickname;
@synthesize fileTransferManager;

- (void)setNickname:(NSString *)aNickname
{
    client->getNickManager()->setOwnNick(NSString2std_str(aNickname));
}

- (NSString*)nickname
{
    return std_str2NSString(client->getNickManager()->getOwnNick());
}

#pragma mark - Init and dealloc

- (id)initWithAccount: (SWAccount*)aAccount
             password: (NSString*)aPasswd
            eventLoop: (SWEventLoop*)aEventLoop
{
    if (self = [super init]) {
        account = aAccount;
        if (account.resources.count < 1) {
            [NSException raise: @"NoResourceException" format: @"There is no available resource for client account."];
        } else {
            // set default resource.
            [account setResourceIndex: 0];
        }
        
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
        
        fileTransferManager = [[SWFileTransferManager alloc] initWithFileTransferManager: client->getFileTransferManager()];
    
        certificateChecker = new SWCertificateTrustChecker(SWCertificateTrustChecker(^BOOL(NSString *subject) {
            return [managedObject clientShouldTrustCerficiate: subject];
        }));
        client->setCertificateTrustChecker(certificateChecker);
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
    delete certificateChecker;
}

#pragma mark - Connections

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

#pragma mark Wrap the method of Swift::Client

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

#pragma mark - Send stanza

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

- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     content: (NSString*)content
                 attachments: (nullable NSArray<NSString*>*)filenames
                     handler: (VSSendMessageHandler)handler
{
    Message::ref swmsg = [self createSwiftMessage: targetAccount
                                          Message: content];
    NSDate* timestamp = [NSDate date]; // FIXME: timestamp should be provided by Swiften
    id msgObject = [managedObject clientWillSendMessageTo: targetAccount
                                                  message: content
                                              attachments: filenames
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

/*!
 * @brief Send message to specific account.
 */
- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     content: (NSString*)content
{
    [self sendMessageToAccount: targetAccount
                       content: content
                   attachments: nil
                       handler: nil];
}

- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     content: (NSString*)content
                     handler: (VSSendMessageHandler)handler
{
    [self sendMessageToAccount: targetAccount
                       content: content
                   attachments: nil
                       handler: handler];
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

#pragma mark - Implement invisible presence(XEP-0018 or XEP-0126).

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

#pragma mark Server caps

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

#pragma mark - Client status

- (BOOL)isAvailable
{
    return client->isAvailable();
}

- (BOOL)isActive
{
    return client->isActive();
}

#pragma mark - Set client attributes

/*!
 * Set client software name, version and OS.
 */
- (void)setSoftwareName: (NSString*)name
         currentVersion: (NSString*)version
              currentOS: (NSString*)os
{
    client->setSoftwareVersion(NSString2std_str(name), NSString2std_str(version), NSString2std_str(os));
}

/*!
 * Set client software name and version.
 */
- (void)setSoftwareName: (NSString*)name
         currentVersion: (NSString*)version
{
    client->setSoftwareVersion(NSString2std_str(name), NSString2std_str(version));
}

/*!
 * Set disoInfo of client with all supported features.
 */
- (void)setDiscoInfo: (NSString*)clientName
            capsNode: (NSString*)node
            features: (NSArray<NSString*>*)features
{
    DiscoInfo discoInfo;
    discoInfo.addIdentity(DiscoInfo::Identity(NSString2std_str(clientName)));
    for (NSString* feature in features) {
        discoInfo.addFeature(NSString2std_str(feature));
    }
    client->getDiscoManager()->setCapsNode(NSString2std_str(node));
    client->getDiscoManager()->setDiscoInfo(discoInfo);
}

#pragma mark - ClientOptions

/*!
 * @brief Set manual host name of server, like www.xx.com or 192.168.0.1, etc.
 */
- (void)setManualHostname: (NSString*)manualHostname
{
    options.manualHostname = NSString2std_str(manualHostname);
}

/*!
 * @brief Set maunal port. By default port would be 5222.
 */
- (void)setManualPort:(int)manualPort {
    options.manualPort = manualPort;
}

@end
