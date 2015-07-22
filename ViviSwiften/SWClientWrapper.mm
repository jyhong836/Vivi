//
//  SWClientAdapter.m
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWClientWrapper.h"
#include <Swiften/Swiften.h>
using namespace Swift;
#import "SWClient.h"

@implementation SWClientWrapper {
    Client *client;
    SimpleEventLoop *eventLoop;
    BoostNetworkFactories *netFactories;
}

- (id)init
{
    if (self = [super init]) {
        eventLoop = new SimpleEventLoop();
        netFactories = new BoostNetworkFactories(eventLoop);
        client = new SWClient("jyhong@xmpp.jp","jyhong123",netFactories);
    }
    return self;
}

- (void)run
{
    eventLoop->run();
}

- (void)runBackgroud
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        eventLoop->run();
    });
}

- (void)connect
{
    client->connect();
}

- (void)dealloc
{
    delete client;
    delete eventLoop;
    delete netFactories;
}

@end
