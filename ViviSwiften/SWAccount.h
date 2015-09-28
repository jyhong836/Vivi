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

/*!
 * @param accountName must be convertible to ASCII C String, or raise Exception.
 */
- (id)initWithAccountName: (NSString *)account;
#ifdef __cplusplus
/*!
 * @brief Init with jid.
 *
 * It will guarantee jid to be bare, and store resource to list if exists.
 */
- (id)initWithJID: (Swift::JID*)ajid;
#endif
- (void)dealloc;

/*!
 * @brief Validate JID.
 */
@property (nonatomic, readonly)BOOL valid;
/*!
 * @brief Account string with preseted resource. By default there
 * is no resource. (read-only)
 */
@property (nonatomic, readonly)NSString* accountString;
@property (nonatomic, readonly)NSString* resourceString;
@property (nonatomic, readonly)NSString* nodeString;
@property (nonatomic, readonly)NSString* domainString;

@property NSMutableArray<NSString*> *resources;
/*!
 * @brief Add resource string to the end of resource list.
 *
 * @return The index of added resource.
 */
- (NSInteger)addResource: (NSString*)resource;
/*!
 * @brief Set which resource will be used by account.
 *
 * The default resource index is -1, which means there is
 * no resource used.
 *
 * IMPORTANT the index should between -1(include) and
 * resources count, else will cause an runtime assert.
 */
- (void)setResourceIndex: (NSInteger)index;
/*!
 * @brief Set resource index to defualt(-1).
 *
 * The default resource index is -1, which means there is
 * no resource used.
 */
- (void)resetResourceIndex;

@end
