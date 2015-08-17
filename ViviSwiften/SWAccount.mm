//
//  SWAccount.m
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWAccount.h"
#import <Swiften/Swiften.h>
using namespace Swift;

@implementation SWAccount {
    int resourceIndex;
}

@synthesize jid;

- (id)initWithAccountName: (NSString *)account
{
    if (self = [super init]) {
        resources = [[NSMutableArray<NSString*> alloc] init];
        jid = new JID(NSString2std_str(account));
        if (!jid->isBare()) {
            [self addResource: [self getResourceString]];
            std::string bareID = jid->toBare().toString();
            delete jid;
            jid = new JID(bareID);
        }
        resourceIndex = -1;
    }
    return self;
}

- (id)initWithJID: (JID*)ajid
{
    if (self = [super init]) {
        resources = [[NSMutableArray<NSString*> alloc] init];
        jid = ajid;
        if (!jid->isBare()) {
            [self addResource: [self getResourceString]];
            std::string bareID = jid->toBare().toString();
            delete jid;
            jid = new JID(bareID);
        }
        resourceIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    delete jid;
}

// MARK: Wrap JID
- (BOOL) valid
{
    if (jid->isValid())
        return YES;
    else
        return NO;
}

@synthesize resources;

- (void)addResource: (NSString*)resource
{
    [resources addObject: resource];
}

- (void)setResourceIndex: (int)index
{
    if (index > 0 && index < resources.count) {
        resourceIndex = index;
        JID *newjid = new JID(jid->getNode(), jid->getDomain(), NSString2std_str(resources[resourceIndex]));
        delete jid;
        jid = newjid;
    } else
        assert(false); // invalid index
}

- (void)resetResourceIndex
{
    resourceIndex = -1;
    JID *newjid = new JID(jid->getNode(), jid->getDomain());
    delete jid;
    jid = newjid;
}

// MARK: Account string access
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
