//
//  SWClient.m
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWClientSlots.h"
#import "SWAccount.h"
#import "VSClientControllerProtocol.h"
#import "VSClientDelegateProtocol.h"

using namespace Swift;

#define GLOBAL_CLIENT_DELEGATE vivi.clientController.clientDelegate

SWClientSlots::SWClientSlots(const JID& jid,
                             const SafeString& password,
                             NetworkFactories* networkFactories,
                             SWClientAdapter* clientAdapter,
                             Storages* storages):
Client(jid, password, networkFactories, storages),
clientAdapter(clientAdapter)
{
    // MARK: Connect signals to slots
    this->onConnected.connect(boost::bind(&SWClientSlots::onConnectedSlot, this));
    this->onMessageReceived.connect(boost::bind(&SWClientSlots::onMessageReceivedSlot, this, _1));
    this->onPresenceReceived.connect(boost::bind(&SWClientSlots::onPresenceReceivedSlot, this, _1));
    this->onDisconnected.connect(boost::bind(&SWClientSlots::onDisconnectedSlot, this, _1));
}

// MARK: SLOTS

void SWClientSlots::onConnectedSlot()
{
    // TODO: do something in Client
    GetRosterRequest::ref rosterRequest =
    GetRosterRequest::create(getIQRouter());
    rosterRequest->onResponse.connect(
                                      bind(&SWClientSlots::onRosterReceivedSlot, this, _1, _2));
    rosterRequest->send();
    
    clientAdapter.isConnected = YES;
    sendPresence(Presence::create("onConnected presence"));
    
    [vivi.clientController.clientDelegate clientDidConnect: clientAdapter];
}

void SWClientSlots::onDisconnectedSlot(const boost::optional<ClientError> &err)
{
    clientAdapter.isConnected = NO;
    if (err) {
        [GLOBAL_CLIENT_DELEGATE clientDidDisonnect: clientAdapter
                                      errorMessage: std_str2NSString(err->getErrorCode()->message())];
    } else {
        [GLOBAL_CLIENT_DELEGATE clientDidDisonnect: clientAdapter
                                      errorMessage: nil];
    }
}

void SWClientSlots::onRosterReceivedSlot(RosterPayload::ref rosterPayload, ErrorPayload::ref err)
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

void SWClientSlots::onMessageReceivedSlot(Message::ref msg)
{
    SWAccount* account = [[SWAccount alloc] init: std_str2NSString(msg->getFrom().toString())];
    NSString* content = std_str2NSString(msg->getBody());
    // FIXME: do we really need to pass a SWAccount? or just str, for search.
    [vivi.clientController.clientDelegate clientDidReceiveMessage: clientAdapter fromAccount:account inContent:content];
}

void SWClientSlots::onPresenceReceivedSlot(Presence::ref pres)
{
    SWAccount* account = [[SWAccount alloc] init: std_str2NSString(pres->getFrom().toString())];
    NSString* status = std_str2NSString(pres->getStatus());
    [GLOBAL_CLIENT_DELEGATE clientDidReceivePresence: clientAdapter
                                         fromAccount: account
                                     currentPresence: pres->getType()
                                         currentShow: pres->getShow()
                                       currentStatus: status];
}
