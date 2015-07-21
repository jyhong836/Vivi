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
//    class Client;
//    class JID;
//    class SafeString;
//    class NetworkFactories;
//    class Storages;
    
    class SWClient: public Swift::Client
    {
        public:
        SWClient(const JID& jid, const SafeString& password, NetworkFactories* networkFactories, Storages* storages = NULL);
        void handleConnected();
    };
}
