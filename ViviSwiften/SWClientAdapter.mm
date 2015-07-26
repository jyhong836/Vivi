//
//  SWClient.m
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWClientAdapter.h"
#import "SWAccount.h"
#import "SWClient.h"
#import "VSClientDelegateProtocol.h"

using namespace Swift;

SWClientAdapter::SWClientAdapter(SWAccount* account,
                             const SafeString& password,
                             NetworkFactories* networkFactories,
                             SWClient* swclient,
                             Storages* storages):
Client(*account.jid, password, networkFactories, storages),
swclient(swclient)
{
    // MARK: Connect signals to slots
    this->onConnected.connect(boost::bind(&SWClientAdapter::onConnectedSlot, this));
    this->onMessageReceived.connect(boost::bind(&SWClientAdapter::onMessageReceivedSlot, this, _1));
    this->onPresenceReceived.connect(boost::bind(&SWClientAdapter::onPresenceReceivedSlot, this, _1));
    this->onDisconnected.connect(boost::bind(&SWClientAdapter::onDisconnectedSlot, this, _1));
}

// MARK: SLOTS

void SWClientAdapter::onConnectedSlot()
{
    // TODO: do something in Client
    GetRosterRequest::ref rosterRequest =
    GetRosterRequest::create(getIQRouter());
    rosterRequest->onResponse.connect(
                                      bind(&SWClientAdapter::onRosterReceivedSlot, this, _1, _2));
    rosterRequest->send();
    
    swclient.isConnected = YES;
    sendPresence(Presence::create("onConnected presence"));
    
    if ([swclient.delegate respondsToSelector:@selector(clientDidConnect:)])
        [swclient.delegate clientDidConnect: swclient];
}

void SWClientAdapter::onDisconnectedSlot(const boost::optional<ClientError> &err)
{
    swclient.isConnected = NO;
    if ([swclient.delegate respondsToSelector:@selector( clientDidDisconnect:errorCode:)]) {
        if (err) {
            [swclient.delegate clientDidDisconnect: swclient
                                     errorCode: err->getType()];
        } else {
            [swclient.delegate clientDidDisconnect: swclient
                                     errorCode: -1];
        }
    }
}

void SWClientAdapter::onRosterReceivedSlot(RosterPayload::ref rosterPayload, ErrorPayload::ref err)
{
    if (err) {
        // TODO: use NS Error Log instead
//        std::cerr << "Error receiving roster. Continuing anyway.";
        NSLog(@"Error receiving roster. Continuing anyway.");
    }
    // TODO: remove the test presence
    // Send initial available presence
//    sendPresence(Presence::create("TEST presence"));
}

void SWClientAdapter::onMessageReceivedSlot(Message::ref msg)
{
    SWAccount* account = [[SWAccount alloc] init: std_str2NSString(msg->getFrom().toString())];
    NSString* content = std_str2NSString(msg->getBody());
    // FIXME: do we really need to pass a SWAccount? or just str, for search.
    if ([swclient.delegate respondsToSelector:@selector( clientDidReceiveMessage:fromAccount:inContent:)])
        [swclient.delegate clientDidReceiveMessage: swclient
                                       fromAccount: account
                                         inContent: content];
}

void SWClientAdapter::onPresenceReceivedSlot(Presence::ref pres)
{
    SWAccount* account = [[SWAccount alloc] init: std_str2NSString(pres->getFrom().toString())];
    NSString* status = std_str2NSString(pres->getStatus());
    if ([swclient.delegate respondsToSelector:@selector( clientDidReceivePresence:fromAccount:currentPresence:currentShow:currentStatus:)])
        [swclient.delegate clientDidReceivePresence: swclient
                                    fromAccount: account
                                currentPresence: pres->getType()
                                    currentShow: pres->getShow()
                                  currentStatus: status];
}
