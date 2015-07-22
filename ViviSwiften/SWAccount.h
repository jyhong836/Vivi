//
//  SWAccount.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
#import <Swiften/Swiften.h>
#endif

@interface SWAccount : NSObject
#ifdef __cplusplus
@property (nonatomic) Swift::JID* jid;
#else
@property (nonatomic) void* jid;
#endif
- (id)init: (NSString *)account;
- (void)dealloc;

@end
