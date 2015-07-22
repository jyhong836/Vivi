//
//  SWAccount.m
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWAccount.h"
using namespace Swift;

@implementation SWAccount

@synthesize jid;

- (id)init: (NSString *)account
{
    if (self = [super init]) {
        jid = new JID([account cStringUsingEncoding:NSASCIIStringEncoding]);
    }
    return self;
}

- (void)dealloc
{
    delete jid;
}

@end
