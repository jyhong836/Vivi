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

// MARK: Wrap JID

- (NSString*)getAccountString
{
    return std_str2NSString(jid->toBare().toString());
}

- (NSString*)getFullAccountString
{
    return std_str2NSString(jid->toString());
}

- (NSString*)getResourceString
{
    // TODO: test what if the getResource return empty?
    return std_str2NSString(jid->getResource());
}

- (NSString*)getNodeString
{
    return std_str2NSString(jid->getNode());
}

- (NSString*)getDomainString
{
    return std_str2NSString(jid->getDomain());
}

@end
