//
//  SWClient.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Swiften/Swiften.h>
#import "SWClientAdapter.h"

namespace Swift
{
    /*!
     * @brief C++ client inherit from Swift::Client.
     *
     * SWClient will connect the signals to class slot methods, and call VSClientDelegate in global VSVivi.
     */
    class SWClientSlots: public Swift::Client
    {
    public:
        SWClientSlots(const JID& jid,
                      const SafeString& password,
                      NetworkFactories* networkFactories,
                      SWClientAdapter* clientAdapter,
                      Storages* storages = NULL);
    private:
        SWClientAdapter* clientAdapter;
        void onConnectedSlot();
        void onRosterReceivedSlot(ErrorPayload::ref err);
        void onMessageReceivedSlot(Message::ref msg);
    };
}
