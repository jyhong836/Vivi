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
#endif

- (id)initWithAccountName: (NSString *)account;
#ifdef __cplusplus
- (id)initWithJID: (Swift::JID*)ajid;
#endif
- (void)dealloc;

@property (nonatomic, readonly)BOOL valid;
@property (nonatomic, readonly)NSString* accountString;
//- (NSString*)getFullAccountString;
@property (nonatomic, readonly)NSString* resourceString;
@property (nonatomic, readonly)NSString* nodeString;
@property (nonatomic, readonly)NSString* domainString;

@property NSMutableArray<NSString*> *resources;
- (NSInteger)addResource: (NSString*)resource;
- (void)setResourceIndex: (NSInteger)index;
- (void)resetResourceIndex;

@end
