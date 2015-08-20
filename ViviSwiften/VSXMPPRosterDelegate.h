//
//  VSXmppRosterDelegate.h
//  Vivi
//
//  Created by Junyuan Hong on 7/30/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

@class SWAccount;
@class SWXMPPRoster;
@class SWRosterItem;

@protocol VSXMPPRosterDelegate <NSObject>

@optional
- (void)roster: (SWXMPPRoster*)roster
 didAddAccount: (SWAccount*)account;
@optional
- (void)roster: (SWXMPPRoster*)roster
didRemoveAccount: (SWAccount*)account;
@optional
- (void)roster: (SWXMPPRoster*)roster
 didUpdateItem: (SWRosterItem*)item;
@optional
- (void)rosterDidClear: (SWXMPPRoster*)roster;
@optional
- (void)rosterDidInitialize: (SWXMPPRoster*)roster;

@end
