//
//  SWRosterItem.m
//  Vivi
//
//  Created by Junyuan Hong on 8/17/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWRosterItem.h"
#import "SWAccount.h"
#import <Swiften/Swiften.h>
using namespace Swift;

@implementation SWRosterItem {
//    XMPPRosterItem* item;
}

@synthesize name;
@synthesize account;
@synthesize groups;

- initWithRosterItem: (XMPPRosterItem*)item
{
    if (self = [super init]) {
//        item = anItem;
        name = std_str2NSString(item->getName());
        account = [[SWAccount alloc] initWithAccountName: std_str2NSString(item->getJID().toString())];
        groups = [[NSMutableArray alloc] init];
        for (auto &group: item->getGroups()) {
            [groups addObject: std_str2NSString(group)];
        }
    }
    return self;
}

@end
