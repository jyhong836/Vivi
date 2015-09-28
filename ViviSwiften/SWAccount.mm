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

}

@synthesize jid;

- (id)initWithAccountName: (NSString *)account
{
    if (self = [super init]) {
        jid = new JID(NSString2std_str(account));
    }
    return self;
}

- (id)initWithJID: (const Swift::JID&)ajid
{
    if (self = [super init]) {
        jid = new JID(ajid.getNode(), ajid.getDomain(), ajid.getResource());
    }
    return self;
}


- (SWAccount*)toBare
{
    return [[SWAccount alloc]initWithJID: jid->toBare()];
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

- (BOOL)bare
{
    if (jid->isBare())
        return YES;
    else
        return NO;
}

#pragma mark - Account string access

- (NSString*)string
{
    return std_str2NSString(jid->toString());
}

- (NSString*)bareString
{
    return std_str2NSString(jid->toBare().toString());
}

- (NSString*)resource
{
    // TODO: test what if the getResource return empty?
    return std_str2NSString(jid->getResource());
}

- (NSString*)node
{
    return std_str2NSString(jid->getNode());
}

- (NSString*)domain
{
    return std_str2NSString(jid->getDomain());
}

@end
