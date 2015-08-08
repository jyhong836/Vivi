//
//  SWAccount.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//
#ifdef __cplusplus
namespace Swift {
    class JID;
}
#endif

@interface SWAccount : NSObject
#ifdef __cplusplus
@property (readonly, nonatomic) Swift::JID* jid;
#else
@property (readonly, nonatomic) void* jid;
#endif
/*!
 * @param accountName must be convertible to ASCII C String, or raise Exception.
 */
- (id)initWithAccountName: (NSString *)account;
- (void)dealloc;

@property (nonatomic, readonly)BOOL valid;
- (NSString*)getAccountString;
//- (NSString*)getFullAccountString;
- (NSString*)getResourceString;
- (NSString*)getNodeString;
- (NSString*)getDomainString;

@property NSMutableArray<NSString*> *resources;
- (void)addResource: (NSString*)resource;
- (void)setResourceIndex: (int)index;
- (void)resetResourceIndex;

@end
