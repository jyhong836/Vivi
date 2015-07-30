//
//  VSXmppRosterDelegate.h
//  Vivi
//
//  Created by Junyuan Hong on 7/30/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

@class SWAccount;

@protocol VSXMPPRosterDelegate <NSObject>

@optional
- (void)rosterDidAddAccount: (SWAccount*)account;
@optional
- (void)rosterDidRemoveAccount: (SWAccount*)account;
@optional
- (void)rosterDidUpdate;
@optional
- (void)rosterDidClear;
@optional
- (void)rosterDidInitialize;

@end
