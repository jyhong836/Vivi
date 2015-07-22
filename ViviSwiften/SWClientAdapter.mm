//
//  SWClientAdapter.m
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWClientAdapter.h"
#include <Swiften/Swiften.h>
using namespace Swift;
#import "SWClient.h"

@implementation SWClientAdapter {
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

- (void)dealloc
{
    delete client;
    delete eventLoop;
    delete netFactories;
}

// MARK: Wrap the method of Swift::Client

- (void)run
{
    eventLoop->run();
}

/*!
 * @brief Run SimpleEventLoop at global queue at background.
 */
- (void)runBackgroud
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        eventLoop->run();
    });
}

- (void)connect
{
    NSLog(@"Connecting");
    client->connect();
}

@end
