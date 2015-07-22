//
//  SWClient.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <Swiften/Swiften.h>

namespace Swift
{
    /*!
     * @brief C++ client inherit from Swift::Client.
     *
     * SWClient will connect the signals to class methods, and call VSClientDelegate in global VSVivi.
     */
    class SWClient: public Swift::Client
    {
        public:
        SWClient(const JID& jid, const SafeString& password, NetworkFactories* networkFactories, Storages* storages = NULL);
        void handleConnected();
    };
}
