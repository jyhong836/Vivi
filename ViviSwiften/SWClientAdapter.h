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
#import <Swiften/Swiften.h>

@class SWAccount;
@class SWClient;

namespace Swift
{
    /*!
     * @brief C++ client inherit from Swift::Client.
     *
     * SWClient will connect the signals to class slot methods, and call VSClientDelegate in global VSVivi.
     */
    class SWClientAdapter: public Swift::Client
    {
    public:
        SWClientAdapter(SWAccount* account,
                      const SafeString& password,
                      NetworkFactories* networkFactories,
                      SWClient* clientAdapter,
                      Storages* storages = NULL);
        ~SWClientAdapter();
    private:
        /// Never free swclient inside SWClientAdapter
        SWClient* __weak swclient;
        void onConnectedSlot();
        void onDisconnectedSlot(const boost::optional<ClientError> &err);
        void onRosterReceivedSlot(RosterPayload::ref rosterPayload,ErrorPayload::ref err);
        void onMessageReceivedSlot(Message::ref msg);
        void onPresenceReceivedSlot(Presence::ref pres);
        
    private:
        void rosterOnJIDAddedSlot(const JID& jid);
        void rosterOnJIDRemovedSlot(const JID& jid);
        void rosterOnJIDUpdatedSlot(const JID&, const std::string&, const std::vector<std::string>&);
        void rosterOnRosterClearedSlot();
        void rosterOnInitialRosterPopulatedSlot();
    };
}

#endif // !define(__cplusplus)
