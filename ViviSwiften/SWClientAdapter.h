//
//  SWClient.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#ifndef __cplusplus
#error "SWClientAdapter.h" is a C++ header, which shouldn't be included in non-C++ file
#else
#import <Swiften/Client/Client.h>
#import <Swiften/Base/API.h>
#import <Swiften/Elements/DiscoInfo.h>
#import <Swiften/Elements/ErrorPayload.h>

@class SWAccount;
@class SWClient;

namespace Swift
{
    /*!
     * @brief C++ client inherit from Swift::Client.
     *
     * SWClient will connect the signals to class slot methods, and call VSClientDelegate in global VSVivi.
     */
    class SWIFTEN_API SWClientAdapter: public Client
    {
    public:
        SWClientAdapter(SWAccount* account,
                      const SafeString& password,
                      NetworkFactories* networkFactories,
                      SWClient* clientAdapter,
                      Storages* storages = NULL);
        ~SWClientAdapter();
        
#pragma mark - Client action slots
        
    private:
        /// Never free swclient inside SWClientAdapter
        SWClient* __weak swclient;
        void onConnectedSlot();
        void onDisconnectedSlot(const boost::optional<ClientError> &err);
        void onMessageReceivedSlot(boost::shared_ptr<Message> msg);
        void onPresenceReceivedSlot(boost::shared_ptr<Presence> pres);
        
#pragma mark - Sever discoInfo slots
        
    private:
        DiscoInfo::ref serverDiscInfo_;
        void onServerDiscoInfoReceivedSlot(boost::shared_ptr<DiscoInfo> discoInfo, ErrorPayload::ref err);
        void printFeatures(); // print server features
        void printFeatures(const JID& jid); // print account features
    public:
        bool hasInitializedServerDiscoInfo();
        bool serverHasFeature(const std::string &feature);
        void requestServerDiscoInfo();
    
#pragma mark - Roster slots
        
    private:
        void rosterOnJIDAddedSlot(const JID& jid);
        void rosterOnJIDRemovedSlot(const JID& jid);
        void rosterOnJIDUpdatedSlot(const JID&, const std::string&, const std::vector<std::string>&);
        void rosterOnRosterClearedSlot();
        void rosterOnInitialRosterPopulatedSlot();
        
#pragma mark - Avatar slots
        
    private:
        void clientOnJIDAvatarChanged(const JID& jid);
        
#pragma mark - CapsProivder slots
        
    private:
        void onCapsChangedSlot(const JID& jid);
        
    };
    
}

#endif // !define(__cplusplus)
