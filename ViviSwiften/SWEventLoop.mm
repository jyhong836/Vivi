//
//  SWEventLoop.m
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWEventLoop.h"
#include <Swiften/Swiften.h>
using namespace Swift;

@implementation SWEventLoop {
    SimpleEventLoop *eventLoop;
    BoostNetworkFactories *netFactories;
}

- (id)init
{
    if (self = [super init]) {
        eventLoop = new SimpleEventLoop();
        netFactories = new BoostNetworkFactories(eventLoop);
    }
    return self;
}

/*!
 * @brief Run SimpleEventLoop at global queue at background.
 */
- (void)start
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        eventLoop->run();
    });
}

- (BoostNetworkFactories *)getNetworkFactories
{
    return netFactories;
}

- (void)dealloc
{
    delete eventLoop;
    delete netFactories;
}

@end
