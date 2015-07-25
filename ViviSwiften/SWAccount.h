//
//  SWAccount.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#ifdef __cplusplus
#import <Swiften/Swiften.h>
#endif

@interface SWAccount : NSObject
#ifdef __cplusplus
@property (readonly, nonatomic) Swift::JID* jid;
#else
@property (readonly, nonatomic) void* jid;
#endif
- (id)init: (NSString *)account;
- (void)dealloc;

- (NSString*)getAccountString;
- (NSString*)getFullAccountString;
- (NSString*)getResourceString;
- (NSString*)getNodeString;
- (NSString*)getDomainString;

@end
