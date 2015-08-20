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
#import "SWXMPPRoster.h"
#import "VSClientDelegateProtocol.h"
#import "VSClientControllerProtocol.h"
#import "VSXMPPRosterDelegate.h"

using namespace Swift;

SWClientAdapter::SWClientAdapter(SWAccount* account,
                             const SafeString& password,
                             NetworkFactories* networkFactories,
                             SWClient* swclient,
                             Storages* storages):
Client(*account.jid, password, networkFactories, storages),
swclient(swclient)
{
    // Connect signals to client slots
    this->onConnected.connect(boost::bind(&SWClientAdapter::onConnectedSlot, this));
    this->onMessageReceived.connect(boost::bind(&SWClientAdapter::onMessageReceivedSlot, this, _1));
    this->onPresenceReceived.connect(boost::bind(&SWClientAdapter::onPresenceReceivedSlot, this, _1));
    this->onDisconnected.connect(boost::bind(&SWClientAdapter::onDisconnectedSlot, this, _1));
    
    // Connect signals to roster slots
    this->getRoster()->onJIDAdded.connect(boost::bind(&SWClientAdapter::rosterOnJIDAddedSlot, this, _1));
    this->getRoster()->onJIDRemoved.connect(boost::bind(&SWClientAdapter::rosterOnJIDRemovedSlot, this, _1));
    this->getRoster()->onJIDUpdated.connect(boost::bind(&SWClientAdapter::rosterOnJIDUpdatedSlot, this, _1, _2, _3));
    this->getRoster()->onRosterCleared.connect(boost::bind(&SWClientAdapter::rosterOnRosterClearedSlot, this));
    this->getRoster()->onInitialRosterPopulated.connect(boost::bind(&SWClientAdapter::rosterOnInitialRosterPopulatedSlot, this));
}

SWClientAdapter::~SWClientAdapter()
{
    // FIXME: Deconstruct SWClientAdapter.
//    NSLog(@"** Deconstruct SWClientAdapter **");
}

// MARK: SLOTS

void SWClientAdapter::onConnectedSlot()
{
    // TODO: do something in Client
//    GetRosterRequest::ref rosterRequest = GetRosterRequest::create(getIQRouter());
//    rosterRequest->onResponse.connect(bind(&SWClientAdapter::onRosterReceivedSlot, this, _1, _2));
//    rosterRequest->send();
    requestRoster();
    
    // TODO: remove the test presence
    sendPresence(Presence::create(""));
    
    if ([swclient.delegate respondsToSelector:@selector(clientDidConnect:)])
        [swclient.delegate clientDidConnect: swclient];
    if (swclient.connectHandler) {
        swclient.connectHandler(-1);
        [swclient setConnectHandlerToNil];
    }
}

void SWClientAdapter::onDisconnectedSlot(const boost::optional<ClientError> &err)
{
    if ([swclient.delegate respondsToSelector:@selector( clientDidDisconnect:errorCode:)]) {
        if (err) {
            [swclient.delegate clientDidDisconnect: swclient
                                     errorCode: err->getType()];
        } else {
            [swclient.delegate clientDidDisconnect: swclient
                                     errorCode: -1];
        }
    }
    if (swclient.connectHandler) {
        swclient.connectHandler(err->getType());
        [swclient setConnectHandlerToNil];
    }
    if (swclient.disconnectHandler) {
        swclient.disconnectHandler(err->getType());
        [swclient setDisconnectHandlerToNil];
    }
}

//void SWClientAdapter::onRosterReceivedSlot(RosterPayload::ref rosterPayload, ErrorPayload::ref err)
//{
//    if (err) {
//        // TODO: use NS Error Log instead
////        std::cerr << "Error receiving roster. Continuing anyway.";
//        NSLog(@"Error receiving roster. Continuing anyway.");
//    }
//    // TODO: remove the test presence
//    // Send initial available presence
////    sendPresence(Presence::create("TEST presence"));
//}

void SWClientAdapter::onMessageReceivedSlot(Message::ref msg)
{
    SWAccount* account = [[SWAccount alloc] initWithAccountName: std_str2NSString(msg->getFrom().toString())];
    NSString* content = std_str2NSString(msg->getBody());
    
    // TODO: convert the timestamp
    NSDate *date = [NSDate date];
//    double unixTimeStamp = msg->getTimestamp() - boost::gregorian::date(1970,1,1);
//    NSTimeInterval _interval=unixTimeStamp;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    // FIXME: do we really need to pass a SWAccount? or just str, for search.
    if ([swclient.delegate respondsToSelector:@selector( clientDidReceiveMessage:fromAccount:inContent:)])
        [swclient.delegate clientDidReceiveMessage: swclient
                                       fromAccount: account
                                         inContent: content];
    [swclient.managedObject clientDidReceivedMessageFrom: account
                                                      message: content
                                                    timestamp: date];
}

void SWClientAdapter::onPresenceReceivedSlot(Presence::ref pres)
{
    SWAccount* account = [[SWAccount alloc] initWithAccountName: std_str2NSString(pres->getFrom().toString())];
    NSString* status = std_str2NSString(pres->getStatus());
    if ([swclient.delegate respondsToSelector:@selector( clientDidReceivePresence:fromAccount:currentPresence:currentShow:currentStatus:)])
        [swclient.delegate clientDidReceivePresence: swclient
                                    fromAccount: account
                                currentPresence: pres->getType()
                                    currentShow: pres->getShow()
                                  currentStatus: status];
}

// MARK: Roster slots

void SWClientAdapter::rosterOnJIDAddedSlot(const JID& jid)
{
    if ([swclient.roster.delegate respondsToSelector:@selector(roster:didAddAccount:)])
        [swclient.roster.delegate roster: swclient.roster
                           didAddAccount: [[SWAccount alloc] initWithAccountName: std_str2NSString(jid.toString())]];
}

void SWClientAdapter::rosterOnJIDRemovedSlot(const JID& jid)
{
    if ([swclient.roster.delegate respondsToSelector:@selector(roster:didRemoveAccount:)])
        [swclient.roster.delegate roster: swclient.roster
                        didRemoveAccount: [[SWAccount alloc] initWithAccountName: std_str2NSString(jid.toString())]];
}

void SWClientAdapter::rosterOnJIDUpdatedSlot(const JID& jid, const std::string&, const std::vector<std::string>&)
{
    if ([swclient.roster.delegate respondsToSelector:@selector(roster:didUpdateAccount:)])
        // TODO: Complete rosterOnJIDUpdatedSlot param passing
        [swclient.roster.delegate roster: swclient.roster
                        didUpdateAccount: [[SWAccount alloc] initWithAccountName: std_str2NSString(jid.toString())]];
}

void SWClientAdapter::rosterOnRosterClearedSlot()
{
    if ([swclient.roster.delegate respondsToSelector:@selector(rosterDidClear:)])
        [swclient.roster.delegate rosterDidClear: swclient.roster];
}

void SWClientAdapter::rosterOnInitialRosterPopulatedSlot()
{
    if ([swclient.roster.delegate respondsToSelector:@selector(rosterDidInitialize:)])
        [swclient.roster.delegate rosterDidInitialize: swclient.roster];
}
