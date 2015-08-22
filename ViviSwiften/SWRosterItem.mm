//
//  SWRosterItem.m
//  Vivi
//
//  Created by Junyuan Hong on 8/17/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWRosterItem.h"
#import "SWAccount.h"

#import <Swiften/Roster/XMPPRosterItem.h>
using namespace Swift;

@implementation SWRosterItem

@synthesize name;
@synthesize account;
@synthesize groups;

- initWithRosterItem: (XMPPRosterItem*)item
{
    if (self = [super init]) {
        name = std_str2NSString(item->getName());
        account = [[SWAccount alloc] initWithAccountName: std_str2NSString(item->getJID().toString())];
        groups = [[NSMutableArray alloc] init];
        for (auto &group: item->getGroups()) {
            [groups addObject: std_str2NSString(group)];
        }
    }
    return self;
}

- (id)initWithName: (NSString*)aName
       accountName: (NSString*)anAccount
             group: (NSString*)aGroup
{
    if (self = [super init]) {
        name = aName;
        account = [[SWAccount alloc] initWithAccountName: anAccount];
        groups = [[NSMutableArray alloc] init];
        [groups addObject: aGroup];
    }
    return self;
}

@end
