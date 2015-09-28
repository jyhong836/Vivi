//
//  SWAccount.m
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWAccount.h"

#import <Swiften/JID/JID.h>
using namespace Swift;

@implementation SWAccount {
    NSInteger resourceIndex;
}

@synthesize jid;

- (id)initWithAccountName: (NSString *)account
{
    if (self = [super init]) {
        resources = [[NSMutableArray<NSString*> alloc] init];
        jid = new JID(NSString2std_str(account));
        if (!jid->isBare()) {
            [self addResource: self.resourceString];
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
    /// FIXME: This is not safe. The JID used to init may not be released
    /// later.
    if (self = [super init]) {
        resources = [[NSMutableArray<NSString*> alloc] init];
        jid = ajid;
        if (!jid->isBare()) {
            [self addResource: self.resourceString];
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

#pragma mark - Wrap JID functions

- (BOOL)valid
{
    if (jid->isValid())
        return YES;
    else
        return NO;
}

@synthesize resources;

- (NSInteger)addResource: (NSString*)resource
{
    [resources addObject: resource];
    return resources.count - 1;
}

- (void)setResourceIndex: (NSInteger)index
{
    if (index >= -1 && (index < 0 || index < resources.count)) {
        resourceIndex = index;
        JID *newjid;
        if (index != -1)
            newjid = new JID(jid->getNode(), jid->getDomain(), NSString2std_str(resources[resourceIndex]));
        else
            newjid = new JID(jid->getNode(), jid->getDomain());
        delete jid;
        jid = newjid;
    } else {
        NSLog(@"Invalid resource index: %ld", (long)index);
        assert(false); // invalid index
    }
}

- (void)resetResourceIndex
{
    [self setResourceIndex: -1];
}

#pragma mark - Account string access

- (NSString*)accountString
{
    return std_str2NSString(jid->toBare().toString());
}

- (NSString*)fullAccountString
{
    return std_str2NSString(jid->toString());
}

- (NSString*)resourceString
{
    // TODO: test what if the getResource return empty?
    return std_str2NSString(jid->getResource());
}

- (NSString*)nodeString
{
    return std_str2NSString(jid->getNode());
}

- (NSString*)domainString
{
    return std_str2NSString(jid->getDomain());
}

@end
