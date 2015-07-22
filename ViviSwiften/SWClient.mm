//
//  SWClient.m
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWClient.h"
#import "VSSharedVivi.h"
#import "VSClientControllerProtocol.h"
#import "VSClientDelegate.h"

Swift::SWClient::SWClient(const JID& jid, const SafeString& password, NetworkFactories* networkFactories, Storages* storages): Client(jid, password, networkFactories, storages)
{
    this->onConnected.connect(boost::bind(&SWClient::onConnectedSlot, this));
}

void Swift::SWClient::onConnectedSlot()
{
    // TODO: do something in Client
    [vivi.clientController.clientDelegate clientDidConnect:vivi.clientController];
}
