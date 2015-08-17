//
//  SWXMPPRoster.m
//  Vivi
//
//  Created by Junyuan Hong on 7/30/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//
#import "SWXMPPRoster.h"
#import <Swiften/Swiften.h>
#import "SWRosterItem.h"

using namespace Swift;

@implementation SWXMPPRoster {
    XMPPRoster* roster;
}

- (id)init: (XMPPRoster*)aRoster;
{
    if (self = [super init]) {
        roster = aRoster;
    }
    return self;
}

- (void)printItems
{
    for (auto &item: roster->getItems()) {
        NSLog(@"name: \"%s\", id: \"%s\"", item.getName().c_str(), item.getJID().toString().c_str());
        for (auto &group: item.getGroups()) {
            NSLog(@"group: \"%s\"", group.c_str());
        }
    }
}

- (NSSet<NSString*>*)getGroups
{
    std::set<std::string> stdgroups = roster->getGroups();
    NSMutableArray<NSString*>* groupArray = [NSMutableArray alloc];
    for (auto &groupname: stdgroups) {
        [groupArray addObject: std_str2NSString(groupname)];
    }
    NSSet<NSString*>* groups = [[NSSet alloc] initWithArray:groupArray];
    return groups;
}

- (NSArray<SWRosterItem*>*)getItems
{
    NSMutableArray<SWRosterItem*>* itemArray = [NSMutableArray alloc];
    for (auto &item: roster->getItems()) {
        [itemArray addObject: [[SWRosterItem alloc] initWithRosterItem:&item]];
    }
    return itemArray;
}

@end
