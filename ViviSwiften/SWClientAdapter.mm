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
#import "SWRosterItem.h"
#import "VSClientDelegateProtocol.h"
#import "VSClientControllerProtocol.h"
#import "VSXMPPRosterDelegate.h"

#import <boost/bind.hpp>
#import <Swiften/Roster/XMPPRosterImpl.h>
#import <Swiften/Elements/Message.h>
#import <Swiften/Elements/Presence.h>
#import <Swiften/Network/NetworkFactories.h>

//#import <Swiften/Disco/EntityCapsProvider.h>
#import <Swiften/Disco/GetDiscoInfoRequest.h>
#import <Swiften/Avatars/AvatarManagerImpl.h>

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
    
    // Connect singals to avatar slots
    this->getAvatarManager()->onAvatarChanged.connect(boost::bind(&SWClientAdapter::clientOnJIDAvatarChanged, this, _1));
}

SWClientAdapter::~SWClientAdapter()
{
    // FIXME: Deconstruct SWClientAdapter.
//    NSLog(@"** Deconstruct SWClientAdapter **");
}

#pragma mark - Request server caps DiscoInfo

/*!
 * Request server DiscoInfo. Throw exception if client is unavailable.
 */
void SWClientAdapter::requestServerDiscoInfo()
{
    if (this->isAvailable()) {
        GetDiscoInfoRequest::ref infoRequest = GetDiscoInfoRequest::create(JID(this->getJID().getDomain()), this->getIQRouter());
        infoRequest->onResponse.connect(boost::bind(&SWClientAdapter::onServerDiscoInfoReceivedSlot, this, _1, _2));
        NSLog(@"send DiscoInfoRequest");
        infoRequest->send();
    } else {
        [NSException raise: @"UnavailableForAction" format: @"Attempt to request disco info when client is unavailable"];
    }
}

void SWClientAdapter::onServerDiscoInfoReceivedSlot(boost::shared_ptr<DiscoInfo> discoInfo, ErrorPayload::ref err) {
    NSLog(@"receive DiscoInfo");
    this->serverDiscInfo_ = discoInfo;
    if (swclient.updateServerCapsHandler) {
        if (err) {
            swclient.updateServerCapsHandler(std_str2NSString(err->getText()));
        } else {
            swclient.updateServerCapsHandler(nil);
        }
        [swclient setUpdateServerCapsHandlerToNil];
    }
}

void SWClientAdapter::printFeatures()
{
    if (serverDiscInfo_) {
        printf("** Discovered server features **\n");
        for (auto feature: serverDiscInfo_->getFeatures()) {
            printf("%s\n", feature.c_str());
        }
        printf("*** END ***\n");
    }
}

/// Return true if server has feature. Call this after server disco info
/// has been received.
bool SWClientAdapter::serverHasFeature(const std::string &feature)
{
    if (serverDiscInfo_) {
        return serverDiscInfo_->hasFeature(feature);
    } else {
        return false;
    }
}

bool SWClientAdapter::hasInitializedServerDiscoInfo()
{
    return serverDiscInfo_ != NULL;
}

#pragma mark - Transport slots

void SWClientAdapter::onConnectedSlot()
{
    requestRoster();
    
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
    int errcode = -1;
    if (err.is_initialized())
        errcode = err->getType();
    if (swclient.connectHandler) {
        swclient.connectHandler(errcode);
        [swclient setConnectHandlerToNil];
    }
    if (swclient.disconnectHandler) {
        swclient.disconnectHandler(errcode);
        [swclient setDisconnectHandlerToNil];
    }
}

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
    [swclient.managedObject clientDidReceivePresence: swclient
                                         fromAccount: account
                                     currentPresence: pres->getType()
                                         currentShow: pres->getShow()
                                       currentStatus: status];
}

#pragma mark - Roster slots

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

void SWClientAdapter::rosterOnJIDUpdatedSlot(const JID& jid, const std::string& name, const std::vector<std::string>& groups)
{
    if ([swclient.roster.delegate respondsToSelector:@selector(roster:didUpdateItem:)]) {
        XMPPRosterItem *item = new XMPPRosterItem(jid, name, groups, RosterItemPayload::None);
        [swclient.roster.delegate roster: swclient.roster
                           didUpdateItem: [[SWRosterItem alloc] initWithRosterItem: item]];
    }
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

#pragma mark - Avatar slots

void SWClientAdapter::clientOnJIDAvatarChanged(const JID& jid)
{
    NSLog(@"%s avatar changed", jid.toString().c_str());
    // TODO: Call delegate here.
}
