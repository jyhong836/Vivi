//
//  SWClient.m
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWClientSlots.h"
#import "VSSharedVivi.h"
#import "VSClientControllerProtocol.h"
#import "VSClientDelegateProtocol.h"

using namespace Swift;

SWClientSlots::SWClientSlots(const JID& jid,
                             const SafeString& password,
                             NetworkFactories* networkFactories,
                             SWClientAdapter* clientAdapter,
                             Storages* storages):
Client(jid, password, networkFactories, storages),
clientAdapter(clientAdapter)
{
    this->onConnected.connect(boost::bind(&SWClientSlots::onConnectedSlot, this));
    this->onMessageReceived.connect(boost::bind(&SWClientSlots::onMessageReceivedSlot, this, _1));
}

void SWClientSlots::onConnectedSlot()
{
    // TODO: do something in Client
    GetRosterRequest::ref rosterRequest =
    GetRosterRequest::create(getIQRouter());
    rosterRequest->onResponse.connect(
                                      bind(&SWClientSlots::onRosterReceivedSlot, this, _2));
    rosterRequest->send();
    
    [vivi.clientController.clientDelegate clientDidConnect: clientAdapter];
}

void SWClientSlots::onRosterReceivedSlot(ErrorPayload::ref err)
{
    if (err) {
        std::cerr << "Error receiving roster. Continuing anyway.";
    }
    // TODO: remove the test presence
    // Send initial available presence
    sendPresence(Presence::create("TEST"));
}

void SWClientSlots::onMessageReceivedSlot(Message::ref msg)
{
    NSString* fromAccount = [NSString stringWithCString: msg->getFrom().toString().c_str() encoding: [NSString defaultCStringEncoding]];
    NSString* content = [NSString stringWithCString: msg->getBody().c_str() encoding: [NSString defaultCStringEncoding]];
    [vivi.clientController.clientDelegate clientDidReceiveMessage: clientAdapter fromAccount:fromAccount inContent:content];
}
