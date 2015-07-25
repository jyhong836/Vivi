//
//  SWClient.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWClient.h"

#ifndef __cplusplus
#error include a C++ header in non-C++ file
#else
#import <Swiften/Swiften.h>


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
        SWClientAdapter(const JID& jid,
                      const SafeString& password,
                      NetworkFactories* networkFactories,
                      SWClient* clientAdapter,
                      Storages* storages = NULL);
    private:
        SWClient* swclient;
        void onConnectedSlot();
        void onDisconnectedSlot(const boost::optional<ClientError> &err);
        void onRosterReceivedSlot(RosterPayload::ref rosterPayload,ErrorPayload::ref err);
        void onMessageReceivedSlot(Message::ref msg);
        void onPresenceReceivedSlot(Presence::ref pres);
    };
}

#endif // !define(__cplusplus)
